# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2025_03_14_025658) do
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
    t.string "jwt_token"
  end

  create_table "companies", force: :cascade do |t|
    t.string "company_name"
    t.string "fantasy_name"
    t.string "cnpj", null: false
    t.date "opening_date"
    t.string "legal_nature"
    t.string "primary_activity_code"
    t.string "primary_activity_text"
    t.string "situation"
    t.string "address"
    t.string "number"
    t.string "neighborhood"
    t.string "city"
    t.string "state"
    t.string "zip_code"
    t.string "phone"
    t.decimal "capital_social", default: "0.0"
    t.decimal "balance"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cnpj"], name: "index_companies_on_cnpj", unique: true
  end

  create_table "companys", force: :cascade do |t|
    t.string "company_name"
    t.string "fantasy_name"
    t.string "cnpj"
    t.date "opening_date"
    t.string "legal_nature"
    t.string "primary_activity_code"
    t.string "primary_activity_text"
    t.string "situation"
    t.string "address"
    t.string "number"
    t.string "neighborhood"
    t.string "city"
    t.string "state"
    t.string "zip_code"
    t.string "phone"
    t.decimal "capital_social"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "balance"
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
