class CreateOrders < ActiveRecord::Migration[7.1]
  def change
    create_table :orders do |t|
      t.float :subtotal
      t.float :total
      t.string :shipping
      t.string :billing
      t.belongs_to :user
      t.integer :status, default: 0

      t.timestamps
    end
  end
end
