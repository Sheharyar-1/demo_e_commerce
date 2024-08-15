class CreateOrderItems < ActiveRecord::Migration[7.1]
  def change
    create_table :order_items do |t|
      t.float :unit_price
      t.integer :quantity
      t.float :total_price
      t.belongs_to :product
      t.belongs_to :order

      t.timestamps
    end
  end
end
