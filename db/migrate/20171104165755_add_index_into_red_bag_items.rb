class AddIndexIntoRedBagItems < ActiveRecord::Migration[5.1]
  def change
    add_index :red_bag_items, :user_id
  end
end
