# Este arquivo é gerado automaticamente a partir do estado atual do banco de dados. Em vez
# de editar este arquivo, por favor, use o recurso de migrações do Active Record para
# modificar incrementalmente seu banco de dados e, em seguida, regenerar esta definição de esquema.
#
# Este arquivo é usado pelo Rails para definir seu esquema ao executar `bin/rails
# db:schema:load`. Ao criar um novo banco de dados, `bin/rails db:schema:load` tende a
# ser mais rápido e potencialmente menos propenso a erros do que executar todas as suas
# migrações do zero. Migrações antigas podem falhar em ser aplicadas corretamente se essas
# migrações usarem dependências externas ou código da aplicação.
#
# É altamente recomendado que você faça o commit deste arquivo em seu sistema de controle de versão.

ActiveRecord::Schema[7.1].define(version: 2024_08_18_233851) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accounts", force: :cascade do |t|
    t.string "name"
    t.date "birthdate"
    t.string "document"
    t.decimal "balance", default: "0.0"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "password_digest"
  end

  create_table "transactions", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.string "transaction_type"
    t.decimal "amount"
    t.decimal "balance_before"
    t.decimal "balance_after"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_transactions_on_account_id"
  end

  create_table "transfers", force: :cascade do |t|
    t.bigint "sender_account_id", null: false
    t.bigint "receiver_account_id", null: false
    t.decimal "amount", precision: 15, scale: 2, null: false
    t.string "transfer_type", default: "transfer", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["receiver_account_id"], name: "index_transfers_on_receiver_account_id"
    t.index ["sender_account_id"], name: "index_transfers_on_sender_account_id"
  end

  add_foreign_key "transactions", "accounts"
  add_foreign_key "transfers", "accounts", column: "receiver_account_id"
  add_foreign_key "transfers", "accounts", column: "sender_account_id"
end
