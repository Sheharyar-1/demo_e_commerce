class CreateProducts < ActiveRecord::Migration[7.1]
  def change
    create_table :products do |t|
      t.string :name
      t.text :description
      t.float :price, precision: 10, scale: 2, null: false
      t.integer :total_quantity
      t.integer :stock

      t.timestamps
    end
  end
end
