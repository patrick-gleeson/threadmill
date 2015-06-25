require 'rails_helper'

RSpec.describe Item, type: :model do
  
  let(:item) { build(:item) }
  
  describe "ActiveRecord associations" do
    it { expect(item).to have_many(:stock_effects) }
  end
  
  describe "ActiveModel validations" do
    it { expect(item).to validate_presence_of(:name) }
    it { expect(item).to validate_numericality_of(:price_cents).is_greater_than(0) }
    
    it { expect(item).to allow_value("10").for(:price_dollars) }
    it { expect(item).to allow_value("10.03").for(:price_dollars) }
    
    it "disallows invalid dollar values" do
      item.price_dollars = "NaN"
      expect(item).not_to be_valid
    end
  end
  
  describe "public instance methods" do
    context "responds to its methods" do
      it { expect(item).to respond_to(:setup_stock_effects) }
      it { expect(item).to respond_to(:price_dollars) }
      it { expect(item).to respond_to(:price_dollars_with_symbol) }
    end
 
    context "executes methods correctly" do
      
      describe "#setup_stock_effects" do
        
        it "builds a stock effect for every stock" do
          item = Item.new
          create_list(:stock, 5)
          item.setup_stock_effects
          expect(item.stock_effects.length).to eq 5
        end
        
        it "doesn't save stock effects" do
          item = Item.new
          create_list(:stock, 5)
          item.setup_stock_effects
          expect(item.stock_effects.select {|se| se.persisted?}.count).to eq 0
        end
        
        it "associates stock effects with stocks" do
          item = Item.new
          created_stocks = create_list(:stock, 5)
          item.setup_stock_effects
          expect(item.stock_effects.map {|se| se.stock}.sort).to eq created_stocks.sort
        end
      end
      
      context "#price_dollars" do
        it "converts cents to dollars" do
          item.price_cents = 123
          expect(item.price_dollars).to eq("1.23")
        end
        
        it "keeps 2 decimal places" do
          item.price_cents = 100
          expect(item.price_dollars).to eq("1.00")
        end
      end
      
      context "#price_dollars=" do
        it "converts converts dollars to cents" do
          item.price_dollars = "1"
          expect(item.price_cents).to eq(100)
        end
      end
      
      context "#price_dollars_with_symbol" do
        it "adds a dollar sign" do
          item.price_dollars = "1.00"
          expect(item.price_dollars_with_symbol).to eq("$1.00")
        end
      end
    end
  end  
end
