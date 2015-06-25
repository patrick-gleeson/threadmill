class CreateStockEffects < ActiveRecord::Migration
  def change
    create_table :stock_effects do |t|
      t.references :stock, index: true, foreign_key: true
      t.references :item, index: true, foreign_key: true
      t.integer :change

      t.timestamps null: false
    end
  end
end
