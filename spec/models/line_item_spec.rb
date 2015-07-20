require 'rails_helper'

RSpec.describe LineItem, type: :model do
  let(:line_item) { build(:line_item) }

  describe 'ActiveRecord associations' do
    it { expect(line_item).to belong_to(:order) }
    it { expect(line_item).to belong_to(:item) }
  end

  describe 'ActiveModel validations' do
    it { expect(line_item).to validate_numericality_of(:quantity).is_greater_than(0) }
  end

  context 'callbacks' do
    it { expect(line_item).to callback(:set_price_at_purchase).before(:validation) }
    it { expect(line_item).to callback(:change_stock).before(:save) }
    it { expect(line_item).to callback(:unchange_stock).before(:destroy) }

    describe 'set_price_at_purchase' do
      it 'captures item price' do
        line_item.item.price_cents = 800
        line_item.save
        line_item.item.price_cents = 600
        line_item.item.save
        line_item.reload
        expect(line_item.price_at_purchase.cents).to eq 800
      end
    end

    describe 'change_stock' do
      it 'changes stock levels on creation' do
        stock = create :stock
        item = create :item
        stock_effect = create :stock_effect, item: item, stock: stock
        item.reload
        line_item.item = item
        expected_stock_level = stock.level - (line_item.quantity * stock_effect.change)

        line_item.save
        stock.reload
        expect(stock.level).to eq expected_stock_level
      end
    end

    describe 'unchange_stock' do
      it 'changes stock levels on destroy' do
        stock = create :stock
        item = create :item
        create :stock_effect, item: item, stock: stock

        item.reload
        line_item.item = item
        expected_stock_level = stock.level

        line_item.save
        line_item.destroy
        stock.reload
        expect(stock.level).to eq expected_stock_level
      end
    end
  end

  describe 'public instance methods' do
    context 'responds to its methods' do
      it { expect(line_item).to respond_to(:price_at_purchase) }
      it { expect(line_item).to respond_to(:total_price) }
      it { expect(line_item).to respond_to(:zero_quantity?) }
    end

    context 'executes methods correctly' do
      describe '#price_at_purchase' do
        it 'converts cents to dollars and adds a $' do
          line_item.price_at_purchase_cents = 100
          expect(line_item.price_at_purchase.format).to eq('$1.00')
        end
      end

      describe '#total_price' do
        it 'multiplies quantity by item price' do
          line_item.price_at_purchase_cents = 100
          line_item.quantity = 3
          expect(line_item.total_price.cents).to eq(300)
        end
      end

      describe '#zero_quantity?' do
        it 'returns false if quantity > 0' do
          line_item.quantity = 3
          expect(line_item.zero_quantity?).to eq false
        end

        it 'returns false if quantity < 0' do
          line_item.quantity = -3
          expect(line_item.zero_quantity?).to eq false
        end

        it 'returns true if quantity == 0' do
          line_item.quantity = 0
          expect(line_item.zero_quantity?).to eq true
        end

        it 'returns true if quantity is nil' do
          line_item.quantity = nil
          expect(line_item.zero_quantity?).to eq true
        end

        it 'returns true if quantity is blank' do
          line_item.quantity = ''
          expect(line_item.zero_quantity?).to eq true
        end

        it 'returns true if quantity is NaN' do
          line_item.quantity = 'Something invalid'
          expect(line_item.zero_quantity?).to eq true
        end
      end
    end
  end
end
