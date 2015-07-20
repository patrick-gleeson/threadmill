require 'rails_helper'

RSpec.describe 'items/edit', type: :view do
  before(:each) do
    @item = assign(:item, create(:item, stock_effects: [build(:stock_effect)]))
  end

  it 'renders the edit item form' do
    render

    assert_select 'form[action=?][method=?]', item_path(@item), 'post' do
      assert_select 'input#item_name[name=?]', 'item[name]'

      assert_select 'input#item_price[name=?]', 'item[price]'

      assert_select 'input#item_stock_effects_attributes_0_change[name=?]',
                    'item[stock_effects_attributes][0][change]'
    end
  end
end
