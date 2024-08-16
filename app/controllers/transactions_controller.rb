class TransactionsController < ApplicationController
  def create
    account = Account.find(params[:account_id])
    balance_before = account.balance || 0.0
    transaction_type = params[:transaction][:transaction_type]
    amount = params[:transaction][:amount].to_d

    # Verifica se é debito e se tem dinheiro suficiente
    if transaction_type == 'debit' && amount > balance_before
      return render json: { errors: ['Dinheiro insuficiente'] }, status: :unprocessable_entity
    end

    balance_after = transaction_type == 'debit' ? balance_before - amount : balance_before + amount

    transaction = account.transactions.create!(
      transaction_type: transaction_type,
      amount: amount,
      balance_before: balance_before,
      balance_after: balance_after
    )

    account.update!(balance: balance_after)

    render json: TransactionSerializer.new(transaction).serializable_hash, status: :created
  rescue => e
    render json: { errors: e.message }, status: :internal_server_error
  end

  def index # usar index em vez de show
    account = Account.find(params[:account_id])
    transactions = account.transactions.order(created_at: :asc)

    response = {
      account: {
        id: account.id,
        name: account.name,
        balance: account.balance
      },
      transactions: transactions.map do |transaction|
        {
          id: transaction.id,
          transaction_type: transaction.transaction_type,
          amount: transaction.amount,
          balance_before: transaction.balance_before,
          balance_after: transaction.balance_after,
          created_at: transaction.created_at
        }
      end
    }

    render json: response, status: :ok
  end
end
