require 'rails_helper'

RSpec.describe "orders/index", type: :view do
  before(:each) do
    orders = [
      create(:order, line_items: [build(:line_item)])
    ]
    @orders = assign(:orders, Kaminari.paginate_array(orders).page(1))
  end

  it "renders a list of orders" do
    render
    assert_select "tr>td", :text => @orders.first.total_formatted, :count => 1
  end
end
