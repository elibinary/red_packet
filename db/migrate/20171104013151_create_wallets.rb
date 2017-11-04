class CreateWallets < ActiveRecord::Migration[5.1]
  def change
    create_table :wallets do |t|
      t.integer :user_id, null: false, comment: '用户 ID'
      t.decimal :balance, null: false, default: 0.0, precision: 12, scale: 2, comment: '余额'

      t.timestamps

      t.index :user_id, unique: true
    end
  end
end
