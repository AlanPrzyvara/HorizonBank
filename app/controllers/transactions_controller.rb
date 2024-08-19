class TransactionsController < ApplicationController
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
  rescue => e
    render json: { errors: e.message }, status: :internal_server_error
  end

  # o index aqui esta listando todos os registros de transações de uma conta
  def index
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

  # usado para mostrar um unico registro de transação
  def show
    account = Account.find(params[:account_id])
    transaction = account.transactions.find(params[:id])

    response = {
      account: {
        id: account.id,
        name: account.name,
        balance: account.balance
      },
      transaction: {
        id: transaction.id,
        transaction_type: transaction.transaction_type,
        amount: transaction.amount,
        balance_before: transaction.balance_before,
        balance_after: transaction.balance_after,
        created_at: transaction.created_at
      }
    }

    render json: response, status: :ok
    # render json: TransactionSerializer.new(transaction).serializable_hash, status: :ok
    # render json: transaction
  end
end

  # COISAS QUE APRENDI FAZENDO ISSO, NÃO TENHA PREGUIÇA DE CRIAR UM NOVO CONTROLER PARA FAZER UMA UNICA FUNÇÃO AAAAAAAA
  # def transfer
  #   from_account = Account.find(params[:account_id])
  #   to_account = Account.find(params[:recipient_id])
  #   amount = params[:transaction][:amount].to_f

  #   if from_account.balance >= amount
  #     ActiveRecord::Base.transaction do
  #       # Transação de débito na conta de origem
  #       from_transaction = from_account.transactions.create!(
  #         transaction_type: 'debit',
  #         amount: amount,
  #         balance_before: from_account.balance,
  #         balance_after: from_account.balance - amount
  #       )

  #       # Atualizar saldo da conta de origem
  #       from_account.update!(balance: from_account.balance - amount)

  #       # Transação de crédito na conta de destino
  #       to_transaction = to_account.transactions.create!(
  #         transaction_type: 'credit',
  #         amount: amount,
  #         balance_before: to_account.balance,
  #         balance_after: to_account.balance + amount
  #       )

  #       # Atualizar saldo da conta de destino
  #       to_account.update!(balance: to_account.balance + amount)
  #     end

  #     receipt = {
  #       transfer_details: {
  #         from: {
  #           id: from_account.id,
  #           name: from_account.name
  #         },
  #         to: {
  #           id: to_account.id,
  #           name: to_account.name
  #         },
  #         transaction_type: 'transfer',
  #         amount: amount,
  #         date: Time.now
  #       }
  #     }

  #     render json: receipt, status: :ok
  #   else
  #     render json: { error: 'Saldo insuficiente' }, status: :unprocessable_entity
  #   end
  # end



# em caso de erro ao criar uma transação, o erro é tratado e retornado no formato json com a mensagem de erro e o status 500
# rescue => e
#   render json: { errors: e.message }, status: :internal_server_error
#   # return render json: { errors: ['Dinheiro insuficiente'] }, status: :unprocessable_entity
# end
