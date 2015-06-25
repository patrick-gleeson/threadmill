# An order is what a customer asks for
class Order < ActiveRecord::Base
  include PriceFormattable
  
  paginates_per 30
  
  belongs_to :user
  has_many :line_items, dependent: :destroy
  accepts_nested_attributes_for :line_items, 
                                reject_if: proc { |attributes| (attributes['quantity'].blank? || 
                                                                attributes['quantity'] == "0")}
                                                                
  validates :total_selected_items, numericality: { greater_than: 0 }
  
  before_save :clear_old_line_items
  before_destroy :clear_old_line_items
  
  def setup_line_items
    Item.all.each do |item|
      unless (line_items.select {|li| li.item == item}.count > 0)
        line_items.build(item: item)
      end
    end
  end
  
  def date_formatted
    created_at.strftime("%A, %d %b %Y")
  end
  
  private
  
  def total_cents
    line_items.inject(0) do |memo, line_item|
      memo += ((line_item.quantity || 0) * (line_item.price_at_purchase || 0))
    end
  end
  
  alias price_cents total_cents
  
  def total_selected_items
    line_items.inject(0) do |memo, line_item|
      if line_item.persisted?
        memo
      else
        memo + line_item.quantity
      end
    end
  end
  
  def clear_old_line_items
    line_items.each do |line_item|
      if line_item.persisted?
        line_items.destroy(line_item)
      end
    end
  end
end
