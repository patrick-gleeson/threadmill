require 'rails_helper'

RSpec.describe DateHelper, type: :helper do
  describe '#format_date' do
    it 'returns the default title' do
      test_date = DateTime.strptime('Monday, 20 Jul 2015', '%A, %d %b %Y')
      expect(helper.format_date(test_date)).to eq('Monday, 20 July 2015')
    end
  end
end
