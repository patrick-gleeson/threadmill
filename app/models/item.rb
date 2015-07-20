# An item is something that might be sold in the shop, such as an espresso
class Item < ActiveRecord::Base
  monetize :price_cents

  scope :all_except, ->(items) { where.not(id: items) }

  has_many :stock_effects, dependent: :delete_all
  accepts_nested_attributes_for :stock_effects

  validates :name, presence: true
  validates :price_cents, presence: true, numericality: { greater_than: 0 }

  before_validation :clear_zero_change_stock_effects

  def current_and_potential_stock_effects
    stock_effects + potential_stock_effects
  end

  private

  def potential_stock_effects
    accounted_for_stocks = stock_effects.map(&:stock)
    unaccounted_for_stocks = Stock.all_except(accounted_for_stocks)
    unaccounted_for_stocks.map { |stock| StockEffect.new(stock: stock) }
  end

  def clear_zero_change_stock_effects
    self.stock_effects = stock_effects.reject do |effect|
      (!effect.persisted?) && (effect.zero_change?)
    end

    stock_effects.select(&:zero_change?).each(&:destroy)
  end
end
