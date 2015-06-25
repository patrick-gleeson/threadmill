# An item is something that might be sold in the shop, such as an espresso
class Item < ActiveRecord::Base
  include PriceFormattable
  
  has_many :stock_effects, dependent: :delete_all
  accepts_nested_attributes_for :stock_effects, 
                                reject_if: proc { |attributes| (attributes['change'].blank? || 
                                                                attributes['change'] == "0")}
  
  validates :name, presence: true
  validates :price_cents, presence: true, numericality: { greater_than: 0 }
  
  before_save :clear_old_stock_effects
  
  def setup_stock_effects
    Stock.all.each do |stock|
      unless (stock_effects.select {|se| se.stock == stock}.count > 0)
        stock_effects.build(stock: stock)
      end
    end
  end
  
  private
  
  def clear_old_stock_effects
    stock_effects.each do |stock_effect|
      stock_effects.delete(stock_effect) if stock_effect.persisted?
    end
  end
end
