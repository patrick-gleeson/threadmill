require 'rails_helper'

RSpec.describe Item, type: :model do
  let(:item) { build(:item) }

  describe 'ActiveRecord associations' do
    it { expect(item).to have_many(:stock_effects) }
    it { expect(item).to accept_nested_attributes_for :stock_effects }
  end

  describe 'ActiveModel validations' do
    it { expect(item).to validate_presence_of(:name) }
    it { expect(item).to validate_numericality_of(:price_cents).is_greater_than(0) }

    it { expect(item).to allow_value('10').for(:price) }
    it { expect(item).to allow_value('10.03').for(:price) }

    it 'disallows invalid price values' do
      item.price = 'NaN'
      expect(item).not_to be_valid
    end
  end

  context 'callbacks' do
    it { expect(item).to callback(:clear_zero_change_stock_effects).before(:validation) }

    describe 'clear_zero_change_stock_effects' do
      it 'removes zero_change unpersisted stock_effects' do
        effect = build :stock_effect, change: 0
        item.stock_effects << effect
        item.save
        expect(item.stock_effects).not_to include effect
      end

      it 'deletes zero_change persisted stock_effects' do
        effect = create :stock_effect
        effect.change = 0
        item.stock_effects << effect
        item.save
        expect(item.stock_effects).not_to include effect
      end

      it 'allows changeful stock_effects' do
        effect = build :stock_effect, change: 10
        item.stock_effects << effect
        item.save
        expect(item.stock_effects).to include effect
      end
    end
  end

  describe 'scopes' do
    it ".all_except doesn't return items passed in" do
      first_item = create(:item)
      second_item = create(:item)
      expect(Item.all_except([second_item])).not_to include(second_item)
    end

    it '.all_except does return items not passed in' do
      first_item = create(:item)
      second_item = create(:item)
      expect(Item.all_except([second_item])).to include(first_item)
    end
  end

  describe 'public instance methods' do
    context 'responds to its methods' do
      it { expect(item).to respond_to(:price) }
      it { expect(item).to respond_to(:current_and_potential_stock_effects) }
    end

    context 'executes methods correctly' do
      describe '#price' do
        it 'converts cents to dollars' do
          item.price_cents = 123
          expect(item.price.format).to eq('$1.23')
        end
      end

      describe '#current_and_potential_stock_effects' do
        it 'includes current stock effects' do
          effect = create :stock_effect
          item.stock_effects << effect
          expect(item.current_and_potential_stock_effects).to include(effect)
        end

        it 'includes unpersisted effects for all stock' do
          stock = create :stock
          expect(item.current_and_potential_stock_effects.first.stock).to eq(stock)
          expect(item.current_and_potential_stock_effects.first).not_to be_persisted
        end
      end
    end
  end
end
