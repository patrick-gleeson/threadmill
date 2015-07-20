require 'rails_helper'

RSpec.describe Order, type: :model do
  let(:order) do
    build :order, line_items: [build(:line_item)]
  end

  describe 'ActiveRecord associations' do
    it { expect(order).to belong_to(:user) }
    it { expect(order).to have_many(:line_items) }
  end

  describe 'ActiveModel validations' do
    it 'disallows orders without items' do
      order.line_items.each do |li|
        li.quantity = 0
      end
      expect(order).not_to be_valid
    end
  end

  describe 'public instance methods' do
    context 'responds to its methods' do
      it { expect(order).to respond_to(:total) }
    end

    context 'executes methods correctly' do
      describe '#total' do
        it 'sums the price at purchase of all line items' do
          line_items = create_list(:line_item, 5)
          order.line_items = line_items
          expected_total = line_items.inject(0) { |m, li| m + (li.quantity * li.price_at_purchase.cents) }
          expect(order.total.cents).to eq expected_total
        end
      end
    end
  end

  describe 'class methods' do
    describe '.page' do
      it 'only returns a max of 30 items' do
        item = create :item
        50.times do
          Order.create!(line_items_attributes: [{ item_id: item.id, quantity: 2 }])
        end
        expect(Order.page(1).count).to eq 30
      end

      it 'returns different results on different pages' do
        item = create :item
        50.times do
          Order.create!(line_items_attributes: [{ item_id: item.id, quantity: 2 }])
        end
        expect((Order.page(1).to_a & Order.page(2).to_a).count).to eq 0
      end
    end
  end
end
