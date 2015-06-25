require 'rails_helper'

RSpec.describe Stock, type: :model do

  let(:stock) {build :stock}
  
  describe "ActiveRecord associations" do
    it { expect(stock).to have_many(:stock_effects) }
  end
  
  describe "ActiveModel validations" do
    it { expect(stock).to validate_presence_of(:name) }
    it { expect(stock).to validate_presence_of(:level) }
    it { expect(stock).to validate_numericality_of(:level).is_greater_than_or_equal_to(0) }
    it { expect(stock).to validate_presence_of(:unit) }
  end
end
