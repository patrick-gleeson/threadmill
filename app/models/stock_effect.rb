# A stock effect models how serving a given item reduces a
# given stock. E.g. an espresso might have a stock effect
# of reducing coffee beans by 25 grams.
class StockEffect < ActiveRecord::Base
  belongs_to :stock
  belongs_to :item  
end
