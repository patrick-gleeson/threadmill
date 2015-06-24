require 'rails_helper'

RSpec.describe LineItem, type: :model do
  let(:line_item) { build(:line_item) }
  
  describe "ActiveRecord associations" do
    it { expect(line_item).to belong_to(:order) }
    it { expect(line_item).to belong_to(:item) }
  end
  
  describe "set_price_at_purchase hook" do
    it "captures item price" do
      line_item.item.price_cents = 800
      line_item.save
      line_item.item.price_cents = 600
      line_item.item.save
      line_item.reload
      expect(line_item.price_at_purchase).to eq 800
      
    end
  end
  
  describe "public instance methods" do
    context "responds to its methods" do
      it { expect(line_item).to respond_to(:price_formatted) }
    end
 
    context "executes methods correctly" do
      context "#price_formatted" do
        it "converts cents to dollars and adds a $" do
          line_item.price_at_purchase = 100
          expect(line_item.price_formatted).to eq("$1.00")
        end
      end
    end
  end  

end
