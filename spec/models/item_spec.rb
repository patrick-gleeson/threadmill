require 'rails_helper'

RSpec.describe Item, type: :model do
  let(:item) { build(:item) }

  describe 'ActiveRecord associations' do
    it { expect(item).to have_many(:stock_effects) }
  end

  describe 'ActiveModel validations' do
    it { expect(item).to validate_presence_of(:name) }
    it { expect(item).to validate_numericality_of(:price_cents).is_greater_than(0) }

    it { expect(item).to allow_value('10').for(:price) }
    it { expect(item).to allow_value('10.03').for(:price) }

    it 'disallows invalid dollar values' do
      item.price_cents = 'NaN'
      expect(item).not_to be_valid
    end
  end

  describe 'public instance methods' do
    context 'responds to its methods' do
      it { expect(item).to respond_to(:price) }
    end

    context 'executes methods correctly' do
      context '#price' do
        it 'converts cents to dollars' do
          item.price_cents = 123
          expect(item.price.format).to eq('$1.23')
        end
      end
    end
  end
end
