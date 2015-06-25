module PriceFormattable
  extend ActiveSupport::Concern
  
  def price_dollars
    '%.02f' % ((price_cents || 0)/100.0)
  end

  def price_dollars_with_symbol
    "$#{price_dollars}"
  end
  
  def price_dollars=(dollar_string)
    self.price_cents = if dollar_string.present?
                         (dollar_string.to_f * 100).round
                       else
                         0
                       end
  end
end