class Order < ActiveRecord::Base
  paginates_per 30
  
  belongs_to :user
  has_many :line_items, dependent: :delete_all
  accepts_nested_attributes_for :line_items, 
                                reject_if: proc { |attributes| (attributes['quantity'].blank? || 
                                                                attributes['quantity'] == "0")}
                                                                
  validates :total_selected_items, numericality: { greater_than: 0 }
  
  before_save :clear_old_line_items
  
  def setup_line_items
    Item.all.each do |item|
      unless (line_items.select {|li| li.item == item}.count > 0)
        line_items.build(item: item)
      end
    end
  end
  
  def total_formatted
    total_dollars = MoneyConversions::Formatter.cents_to_dollar_string(total_cents)
    
    MoneyConversions::Formatter.add_dollar_symbol(total_dollars)
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
      line_items.delete(line_item) if line_item.persisted?
    end
  end
end
