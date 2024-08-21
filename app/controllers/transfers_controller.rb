class TransfersController < ApplicationController
  def create
    sender_account = Account.find(params[:account_id])
    receiver_account = Account.find(transfer_params[:receiver_account_id])

    if sender_account.balance < transfer_params[:amount].to_d
      render json: { error: 'Saldo insuficiente para a transação' }, status: :unprocessable_entity
      return
    end

    ActiveRecord::Base.transaction do
      sender_account.update!(balance: sender_account.balance - transfer_params[:amount].to_d)
      receiver_account.update!(balance: receiver_account.balance + transfer_params[:amount].to_d)

      @transfer = Transfer.create!(
        sender_account: sender_account,
        receiver_account: receiver_account,
        amount: transfer_params[:amount],
        transfer_type: 'transfer'
      )
    end

    render json: TransferSerializer.new(@transfer).serializable_hash.to_json, status: :created
  end

  private

  def transfer_params
    params.require(:transfer).permit(:receiver_account_id, :amount, :password_digest)
  end
end
