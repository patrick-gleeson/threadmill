# A stock is a supply of materials used to prepare items. E.g. Coffee beans
class Stock < ActiveRecord::Base
  has_many :stock_effects
  
  validates :name,  presence: true
  validates :level, presence: true, numericality: {greater_than_or_equal_to: 0}
  validates :unit,  presence: true
end
