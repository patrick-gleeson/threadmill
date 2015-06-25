require 'rails_helper'

RSpec.describe StockEffect, type: :model do
  let(:stock_effect) { build(:stock_effect) }
  
  describe "ActiveRecord associations" do
    it { expect(stock_effect).to belong_to(:stock) }
    it { expect(stock_effect).to belong_to(:item) }
  end

end