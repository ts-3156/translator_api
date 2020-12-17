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

ActiveRecord::Schema.define(version: 2020_12_17_054637) do

  create_table "credentials", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.text "access_token", null: false
    t.text "refresh_token", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["created_at"], name: "index_credentials_on_created_at"
    t.index ["user_id"], name: "index_credentials_on_user_id", unique: true
  end

  create_table "free_licenses", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "key", null: false
    t.datetime "revoked_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["created_at"], name: "index_free_licenses_on_created_at"
    t.index ["key"], name: "index_free_licenses_on_key", unique: true
    t.index ["user_id"], name: "index_free_licenses_on_user_id"
  end

  create_table "pro_licenses", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "subscription_id", null: false
    t.string "key", null: false
    t.datetime "revoked_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["created_at"], name: "index_pro_licenses_on_created_at"
    t.index ["key"], name: "index_pro_licenses_on_key", unique: true
    t.index ["subscription_id"], name: "index_pro_licenses_on_subscription_id"
    t.index ["user_id"], name: "index_pro_licenses_on_user_id"
  end

  create_table "subscriptions", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "email"
    t.string "name"
    t.integer "price"
    t.decimal "tax_rate", precision: 4, scale: 2
    t.string "checkout_session_id"
    t.string "customer_id"
    t.string "subscription_id"
    t.datetime "trial_end_at"
    t.datetime "canceled_at"
    t.datetime "charge_failed_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["created_at"], name: "index_subscriptions_on_created_at"
    t.index ["user_id"], name: "index_subscriptions_on_user_id"
  end

  create_table "translation_requests", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "license_type", null: false
    t.bigint "license_id", null: false
    t.string "source_lang"
    t.string "target_lang"
    t.text "text"
    t.datetime "created_at", null: false
    t.index ["created_at"], name: "index_translation_requests_on_created_at"
  end

  create_table "translation_responses", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "translation_request_id", null: false
    t.string "detected_source_language"
    t.text "text"
    t.datetime "created_at", null: false
    t.index ["created_at"], name: "index_translation_responses_on_created_at"
  end

  create_table "trial_licenses", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "key", null: false
    t.datetime "revoked_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["created_at"], name: "index_trial_licenses_on_created_at"
    t.index ["key"], name: "index_trial_licenses_on_key", unique: true
  end

  create_table "users", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "uid", null: false
    t.string "email", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["created_at"], name: "index_users_on_created_at"
    t.index ["uid"], name: "index_users_on_uid", unique: true
  end

end
