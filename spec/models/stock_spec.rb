require 'rails_helper'

RSpec.describe Stock, type: :model do
  let(:stock) { build :stock }

  describe 'ActiveRecord associations' do
    it { expect(stock).to have_many(:stock_effects) }
  end

  describe 'ActiveModel validations' do
    it { expect(stock).to validate_presence_of(:name) }
    it { expect(stock).to validate_presence_of(:level) }
    it { expect(stock).to validate_numericality_of(:level).is_greater_than_or_equal_to(0) }
    it { expect(stock).to validate_presence_of(:unit) }
  end

  describe 'scopes' do
    it ".all_except doesn't return stocks passed in" do
      first_stock = create(:stock)
      second_stock = create(:stock)
      expect(Stock.all_except([second_stock])).not_to include(second_stock)
    end

    it '.all_except does return stocks not passed in' do
      first_stock = create(:stock)
      second_stock = create(:stock)
      expect(Stock.all_except([second_stock])).to include(first_stock)
    end
  end
end
