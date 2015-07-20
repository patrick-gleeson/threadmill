require 'rails_helper'

RSpec.describe 'stocks/new', type: :view do
  before(:each) do
    assign(:stock, Stock.new(
                     name: 'MyString',
                     level: 1,
                     unit: 'MyString',
                     estimate: false
    ))
  end

  it 'renders new stock form' do
    render

    assert_select 'form[action=?][method=?]', stocks_path, 'post' do
      assert_select 'input#stock_name[name=?]', 'stock[name]'

      assert_select 'input#stock_level[name=?]', 'stock[level]'

      assert_select 'input#stock_unit[name=?]', 'stock[unit]'
    end
  end
end
