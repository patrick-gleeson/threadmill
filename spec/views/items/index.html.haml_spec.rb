require 'rails_helper'

RSpec.describe "items/index", type: :view do
  before(:each) do
    @items = assign(:items, create_list(:item, 2))
  end

  it "renders a list of items" do
    render
    assert_select "tr>td", :text => @items.first.name, :count => 2
    assert_select "tr>td", :text => @items.first.price_dollars_with_symbol, :count => 2
  end
end
