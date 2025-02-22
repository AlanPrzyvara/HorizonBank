class TransactionsController < ApplicationController
  # POST /accounts/:account_id/transactions o create aqui esta criando um novo registro de transação
  def create
    account = Account.find(params[:account_id])
    balance_before = account.balance || 0.0
    transaction_type = params[:transaction][:transaction_type]
    amount = params[:transaction][:amount].to_d
    # Verifica se é debito e se tem dinheiro suficiente
    if transaction_type == 'debit' && amount > balance_before
      return render json: { errors: ['Saldo insuficiente para a transação'] }, status: :unprocessable_entity
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
  end

  # Get /accounts/:account_id/transactions o index aqui esta listando todos os registros de transações de uma conta
  def index
    account = Account.find(params[:account_id])
    transactions = account.transactions.order(created_at: :desc)

    render json: {
    account: AccountSerializer.new(account).serializable_hash,
    transactions: TransactionSerializer.new(transactions).serializable_hash }, status: :ok
  end

  # Get /accounts/:account_id/transactions/:id usado para mostrar um unico registro de transação
  def show
    account = Account.find(params[:account_id])
    transaction = account.transactions.find(params[:id])

    render json: { account: AccountSerializer.new(account).serializable_hash, transactions:
    TransactionSerializer.new(transaction).serializable_hash }, status: :ok
  end
end
