class CreateRedBags < ActiveRecord::Migration[5.1]
  def change
    create_table :red_bags do |t|
      t.integer :user_id, null: false, comment: '用户 ID'
      t.decimal :money, null: false, default: 0.0, precision: 12, scale: 2, comment: '金额'
      t.decimal :balance, null: false, default: 0.0, precision: 12, scale: 2, comment: '余额'
      t.integer :numbers, null: false, comment: '数量'
      t.integer :state, null: false, comment: '状态'
      t.string :token, null: false, limit: 12, comment: '口令'
      # t.string :safe_code, null: false, limit: 36, comment: '描述码'

      t.timestamps

      t.index :user_id
      # t.index :safe_code, unique: true
    end
  end
end
