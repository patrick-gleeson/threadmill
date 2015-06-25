class CreateStocks < ActiveRecord::Migration
  def change
    create_table :stocks do |t|
      t.string :name
      t.integer :level
      t.string :unit
      t.boolean :estimate

      t.timestamps null: false
    end
  end
end
