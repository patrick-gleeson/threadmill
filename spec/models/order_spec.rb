require 'rails_helper'

RSpec.describe Order, type: :model do

  let(:order) {
    build :order, line_items: [build(:line_item)]
  }
  
  describe "ActiveRecord associations" do
    it { expect(order).to belong_to(:user) }
    it { expect(order).to have_many(:line_items) }
  end
  
  describe "ActiveModel validations" do
    it "disallows orders without items" do
      order.line_items.each do |li|
        li.quantity = 0
      end
      expect(order).not_to be_valid
    end
  end
  
  describe "public instance methods" do
    context "responds to its methods" do
      it { expect(order).to respond_to(:setup_line_items) }
      it { expect(order).to respond_to(:price_dollars_with_symbol) }
      it { expect(order).to respond_to(:date_formatted) }
    end
    
    context "executes methods correctly" do
      describe "#setup_line_items" do
        
        it "builds a line item for every item" do
          order = Order.new
          created_items = create_list(:item, 5)
          order.setup_line_items
          expect(order.line_items.length).to eq 5
        end
        
        it "doesn't save line items" do
          order = Order.new
          created_items = create_list(:item, 5)
          order.setup_line_items
          expect(order.line_items.select {|li| li.persisted?}.count).to eq 0
        end
        
        it "associates line items with items" do
          order = Order.new
          created_items = create_list(:item, 5)
          order.setup_line_items
          expect(order.line_items.map {|li| li.item}.sort).to eq created_items.sort
        end
      end
      
      describe "#price_dollars_with_symbol" do
        it "sums the price at purchase of all line items" do
          line_items = create_list(:line_item, 5)
          order.line_items = line_items
          expected_total = line_items.inject(0) {|m, li| m + (li.quantity * li.price_at_purchase)}
          expect(order.price_dollars_with_symbol).to eq "$" + '%.02f' % (expected_total/100.0)
        end
      end
      
      describe "#date_formatted" do
        it "returns the date the order was created" do
          order.created_at = Date.strptime("6/15/2011", '%m/%d/%Y')
          expect(order.date_formatted).to eq "Wednesday, 15 Jun 2011"
        end
      end
    end
  end
  
  describe "class methods" do
    describe ".page" do
      it "only returns a max of 30 items" do
        item = create :item
        50.times do
          Order.create!(line_items_attributes:[{item_id: item.id, quantity: 2}])
        end
        expect(Order.page(1).count).to eq 30
      end
      
      it "returns different results on different pages" do
        item = create :item
        50.times do
          Order.create!(line_items_attributes:[{item_id: item.id, quantity: 2}])
        end
        expect((Order.page(1).to_a & Order.page(2).to_a).count).to eq 0
      end
    end
  end
end
