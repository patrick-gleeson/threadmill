require 'rails_helper'

RSpec.describe Item, type: :model do
  
  let(:item) { build(:item) }
  
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
      it { expect(item).to respond_to(:price_dollars) }
      it { expect(item).to respond_to(:price_formatted) }
    end
 
    context "executes methods correctly" do
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
      
      context "#price_formatted" do
        it "adds a dollar sign" do
          item.price_dollars = "1.00"
          expect(item.price_formatted).to eq("$1.00")
        end
      end
    end
  end  
end
