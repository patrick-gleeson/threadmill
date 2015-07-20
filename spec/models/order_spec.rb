require 'rails_helper'

RSpec.describe Order, type: :model do
  let(:order) do
    build :order, line_items: [build(:line_item)]
  end

  describe 'ActiveRecord associations' do
    it { expect(order).to belong_to(:user) }
    it { expect(order).to have_many(:line_items) }
    it { expect(order).to accept_nested_attributes_for :line_items }
  end

  describe 'ActiveModel validations' do
    it 'disallows orders without items' do
      order.line_items.each do |li|
        li.quantity = 0
      end
      expect(order).not_to be_valid
    end
  end

  context 'callbacks' do
    it { expect(order).to callback(:clear_zero_quantity_line_items).before(:validation) }

    describe 'clear_zero_quantity_line_items' do
      it 'removes zero_quantity unpersisted line items' do
        line_item = build :line_item, quantity: 0
        order.line_items << line_item
        order.save
        expect(order.line_items).not_to include line_item
      end

      it 'deletes zero_quantity persisted line items' do
        line_item = create :line_item
        line_item.quantity = 0
        order.line_items << line_item
        order.save
        expect(order.line_items).not_to include line_item
      end

      it 'allows quantitied line items' do
        line_item = build :line_item, quantity: 10
        order.line_items << line_item
        order.save
        expect(order.line_items).to include line_item
      end
    end
  end

  describe 'public instance methods' do
    context 'responds to its methods' do
      it { expect(order).to respond_to(:total) }
      it { expect(order).to respond_to(:current_and_potential_line_items) }
    end

    context 'executes methods correctly' do
      describe '#total' do
        it 'sums the price at purchase of all line items' do
          line_items = create_list(:line_item, 5)
          order.line_items = line_items

          expected_total = line_items.inject(0) do |a, e|
            a + (e.quantity * e.price_at_purchase.cents)
          end

          expect(order.total.cents).to eq expected_total
        end
      end

      describe '#current_and_potential_line_items' do
        it 'includes current line items' do
          line_item = create :line_item
          order.line_items << line_item
          expect(order.current_and_potential_line_items).to include(line_item)
        end

        it 'includes unpersisted line items for all items' do
          item = create :item
          expect(order.current_and_potential_line_items.map(&:item)).to include(item)
          new_line_item = order.current_and_potential_line_items.find { |line_item| line_item.item == item }
          expect(new_line_item).not_to be_persisted
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
