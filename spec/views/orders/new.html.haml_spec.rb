require 'rails_helper'

RSpec.describe 'orders/new', type: :view do
  before(:each) do
    assign(:order, build(:order, line_items: [build(:line_item)]))
  end

  it 'renders new order form' do
    render

    assert_select 'form[action=?][method=?]', orders_path, 'post' do
      assert_select 'input#order_line_items_attributes_0_quantity[name=?]',
                    'order[line_items_attributes][0][quantity]'
    end
  end
end
