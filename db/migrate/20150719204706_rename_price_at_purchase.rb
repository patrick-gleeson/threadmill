class RenamePriceAtPurchase < ActiveRecord::Migration
  def change
    rename_column :line_items, :price_at_purchase, :price_at_purchase_cents
  end
end
