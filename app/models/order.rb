# An order is what a customer asks for
class Order < ActiveRecord::Base
  paginates_per 30

  belongs_to :user
  has_many :line_items, dependent: :destroy
  accepts_nested_attributes_for :line_items

  validates :total_selected_items, numericality: { greater_than: 0 }

  before_validation :clear_zero_quantity_line_items

  def current_and_potential_line_items
    line_items + potential_line_items
  end

  def total
    @total ||= Money.new(total_cents)
  end

  private

  def potential_line_items
    accounted_for_items = line_items.map(&:item)
    unaccounted_for_items = Item.all_except(accounted_for_items)
    unaccounted_for_items.map { |item| LineItem.new(item: item) }
  end

  def clear_zero_quantity_line_items
    line_items.select(&:zero_quantity?).each(&:destroy)

    self.line_items = line_items.reject do |line_item|
      (!line_item.persisted?) && (line_item.zero_quantity?)
    end
  end

  def total_cents
    line_items.map(&:total_price).sum
  end

  def total_selected_items
    line_items.map(&:quantity).sum
  end
end
