# A line item represents a part of an order that comprises several units of a given item,
# e.g. 2 espressos
class LineItem < ActiveRecord::Base
  monetize :price_at_purchase_cents

  belongs_to :order
  belongs_to :item

  validates :quantity, numericality: { greater_than: 0 }

  before_validation :set_price_at_purchase
  before_save :change_stock
  before_destroy :unchange_stock

  def total_price
    price_at_purchase * quantity
  end

  def zero_quantity?
    quantity.blank? || quantity.to_i == 0
  end

  private

  def change_stock
    item.stock_effects.each do |effect|
      delta = quantity - (quantity_was || 0)
      effect.stock.estimate = true
      effect.stock.decrement! :level, (effect.change * delta)
    end
  end

  def unchange_stock
    item.stock_effects.each do |effect|
      effect.stock.estimate = true
      effect.stock.increment! :level, (effect.change * quantity)
    end
  end

  def set_price_at_purchase
    self.price_at_purchase = item.price
  end
end
