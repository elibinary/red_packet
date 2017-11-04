# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20171104165755) do

  create_table "red_bag_items", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.integer "user_id", null: false, comment: "用户 ID"
    t.integer "red_bag_id", null: false, comment: "红包 ID"
    t.decimal "money", precision: 12, scale: 2, default: "0.0", null: false, comment: "金额"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["red_bag_id", "user_id"], name: "index_red_bag_items_on_red_bag_id_and_user_id", unique: true
    t.index ["user_id"], name: "index_red_bag_items_on_user_id"
  end

  create_table "red_bags", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.integer "user_id", null: false, comment: "用户 ID"
    t.decimal "money", precision: 12, scale: 2, default: "0.0", null: false, comment: "金额"
    t.decimal "balance", precision: 12, scale: 2, default: "0.0", null: false, comment: "余额"
    t.integer "numbers", null: false, comment: "数量"
    t.integer "state", null: false, comment: "状态"
    t.string "token", limit: 12, null: false, comment: "口令"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_red_bags_on_user_id"
  end

  create_table "users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.string "nickname", limit: 191, comment: "昵称"
    t.string "avatar_url", comment: "头像"
    t.string "user_key", limit: 50, null: false, comment: "UserKey"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["nickname"], name: "index_users_on_nickname", unique: true
    t.index ["user_key"], name: "index_users_on_user_key", unique: true
  end

  create_table "wallet_flows", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.integer "wallet_id", null: false, comment: "钱包 ID"
    t.decimal "money", precision: 12, scale: 2, default: "0.0", null: false, comment: "金额"
    t.integer "source", null: false, comment: "来源"
    t.string "description", comment: "描述"
    t.string "transaction_num", null: false, comment: "流水号"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["transaction_num"], name: "index_wallet_flows_on_transaction_num", unique: true
    t.index ["wallet_id"], name: "index_wallet_flows_on_wallet_id"
  end

  create_table "wallets", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.integer "user_id", null: false, comment: "用户 ID"
    t.decimal "balance", precision: 12, scale: 2, default: "0.0", null: false, comment: "余额"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_wallets_on_user_id", unique: true
  end

end
