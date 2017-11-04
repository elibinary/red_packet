class CreateWalletFlows < ActiveRecord::Migration[5.1]
  def change
    create_table :wallet_flows do |t|
      t.integer :wallet_id, null: false, comment: '钱包 ID'
      t.decimal :money, null: false, default: 0.0, precision: 12, scale: 2, comment: '金额'
      t.integer :source, null: false, comment: '来源'
      t.string :description, comment: '描述'
      t.string :transaction_num, null: false, comment: '流水号'

      t.timestamps

      t.index :transaction_num, unique: true
      t.index :wallet_id
    end
  end
end
