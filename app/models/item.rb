class Item < ActiveRecord::Base
  
  validates :name, presence: true
  validates :price_cents, presence: true, numericality: { greater_than: 0 }
  
  def price_dollars
    MoneyConversions::Formatter.cents_to_dollar_string(price_cents)
  end
  
  def price_dollars=(value)
    self.price_cents = MoneyConversions::Formatter.dollar_string_to_cents(value)
  end
  
  def price_formatted
    MoneyConversions::Formatter.add_dollar_symbol(price_dollars)
  end
end
