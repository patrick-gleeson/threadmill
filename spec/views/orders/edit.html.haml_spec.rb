require 'rails_helper'

RSpec.describe "orders/edit", type: :view do
  before(:each) do
    @order = assign(:order, create(:order, line_items: [build(:line_item)]))
  end

  it "renders the edit order form" do
    render

    assert_select "form[action=?][method=?]", order_path(@order), "post" do

      assert_select "input#order_line_items_attributes_0_quantity[name=?]", "order[line_items_attributes][0][quantity]"
    end
  end
end
