require 'rails_helper'

RSpec.describe 'stocks/index', type: :view do
  before(:each) do
    assign(:stocks, [
      Stock.create!(
        name: 'Name',
        level: 300,
        unit: 'XXX',
        estimate: false
      ),
      Stock.create!(
        name: 'Name',
        level: 400,
        unit: 'YYY',
        estimate: true
      )
    ])
  end

  it 'renders a list of stocks' do
    render
    assert_select 'tr>td', text: 'Name'.to_s, count: 2
    expect(rendered).to match(/300/)
    expect(rendered).to match(/XXX/)
    expect(rendered).to match(/400/)
    expect(rendered).to match(/YYY/)
    expect(rendered).to match(/\(estimate\)/)
  end
end
