module MoneyConversions  
  class Formatter  
    class << self
      
      def cents_to_dollar_string(cents)
        '%.02f' % ((cents || 0)/100.0)
      end
  
      def add_dollar_symbol(dollar_string)
        "$#{dollar_string}"
      end
      
      def dollar_string_to_cents(dollar_string)
        return 0 unless dollar_string.present?
        (dollar_string.to_f * 100).round
      end
    end
  end    
end