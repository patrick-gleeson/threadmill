require 'rails_helper'

RSpec.describe StockEffect, type: :model do
  let(:stock_effect) { build(:stock_effect) }

  describe 'ActiveRecord associations' do
    it { expect(stock_effect).to belong_to(:stock) }
    it { expect(stock_effect).to belong_to(:item) }
  end

  describe 'ActiveModel validations' do
    it { expect(stock_effect).to validate_numericality_of(:change).is_greater_than(0) }
  end

  describe 'public instance methods' do
    context 'responds to its methods' do
      it { expect(stock_effect).to respond_to(:zero_change?) }
    end

    context 'executes methods correctly' do
      describe '#zero_change?' do
        it 'returns false if change > 0' do
          stock_effect.change = 3
          expect(stock_effect.zero_change?).to eq false
        end

        it 'returns false if change < 0' do
          stock_effect.change = -3
          expect(stock_effect.zero_change?).to eq false
        end

        it 'returns true if change == 0' do
          stock_effect.change = 0
          expect(stock_effect.zero_change?).to eq true
        end

        it 'returns true if change is nil' do
          stock_effect.change = nil
          expect(stock_effect.zero_change?).to eq true
        end

        it 'returns true if change is blank' do
          stock_effect.change = ''
          expect(stock_effect.zero_change?).to eq true
        end

        it 'returns true if change is NaN' do
          stock_effect.change = 'Something invalid'
          expect(stock_effect.zero_change?).to eq true
        end
      end
    end
  end
end
