class LineItem < ActiveRecord::Base
  belongs_to :order
  belongs_to :item
  
  before_save :set_price_at_purchase
  
  def price_formatted
    MoneyConversions::Formatter.add_dollar_symbol(MoneyConversions::Formatter.cents_to_dollar_string(price_at_purchase))
  end
  
  private
  
  def set_price_at_purchase
    self.price_at_purchase = item.price_cents
  end
end
