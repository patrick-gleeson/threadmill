# A line item represents a part of an order that comprises several units of a given item,
# e.g. 2 espressos
class LineItem < ActiveRecord::Base
  include PriceFormattable
  
  belongs_to :order
  belongs_to :item
  
  before_save :set_price_at_purchase
  
  before_create :change_stock
  before_destroy :unchange_stock
  
  def price_cents
    price_at_purchase
  end
  
  def total_price
    price_cents * quantity
  end
  
  private
  
  # When we save a line item (e.g. 2 espressos)
  # we reduce stock levels by the amount the item affects
  # any given stock multiplied by the quantity of that item.
  # We also flag up that the stock level is now an estimate.
  def change_stock
    item.stock_effects.each do |effect|
      effect.stock.estimate = true
      effect.stock.decrement! :level, (effect.change * quantity)
    end
  end
  
  # When we delete a line item, we undo its effect on stock (but
  # if stock was manually adjusted between creating and deleting the line
  # item this will skew the level, so we flag change as an estimate)
  def unchange_stock
    item.stock_effects.each do |effect|
      effect.stock.estimate = true
      effect.stock.increment! :level, (effect.change * quantity)
    end
  end
  
  def set_price_at_purchase
    self.price_at_purchase = item.price_cents
  end
  
  
end
