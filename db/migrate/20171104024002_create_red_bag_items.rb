class CreateRedBagItems < ActiveRecord::Migration[5.1]
  def change
    create_table :red_bag_items do |t|
      t.integer :user_id, null: false, comment: '用户 ID'
      t.integer :red_bag_id, null: false, comment: '红包 ID'
      t.decimal :money, null: false, default: 0.0, precision: 12, scale: 2, comment: '金额'

      t.timestamps

      t.index [:red_bag_id, :user_id], unique: true
    end
  end
end
