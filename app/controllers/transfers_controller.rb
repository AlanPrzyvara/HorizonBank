class TransfersController < ApplicationController
  def create
    sender_account = Account.find(params[:account_id])
    receiver_account = Account.find(transfer_params[:receiver_account_id])
    amount = transfer_params[:amount].to_d

    if sender_account.balance < amount
      render json: { error: 'Saldo insuficiente para a transação' }, status: :unprocessable_entity
      return
    end

    ActiveRecord::Base.transaction do
      balance_before_sender = sender_account.balance
      balance_after_sender = balance_before_sender - amount
      balance_before_receiver = receiver_account.balance
      balance_after_receiver = balance_before_receiver + amount

      sender_account.update!(balance: balance_after_sender)
      receiver_account.update!(balance: balance_after_receiver)

      @transfer = Transfer.create!(
        sender_account: sender_account,
        receiver_account: receiver_account,
        amount: amount,
        transfer_type: 'transfer'
      )

      # Cria uma transação para o remetente
      sender_account.transactions.create!(
        transaction_type: 'debit',
        amount: amount,
        balance_before: balance_before_sender,
        balance_after: balance_after_sender
      )

      # Cria uma transação para o destinatário
      receiver_account.transactions.create!(
        transaction_type: 'credit',
        amount: amount,
        balance_before: balance_before_receiver,
        balance_after: balance_after_receiver
      )
    end

    render json: TransferSerializer.new(@transfer).serializable_hash.to_json, status: :created
  end

  private

  def transfer_params
    params.require(:transfer).permit(:receiver_account_id, :amount, :password_digest)
  end
end
