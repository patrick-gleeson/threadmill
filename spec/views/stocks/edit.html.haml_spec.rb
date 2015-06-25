require 'rails_helper'

RSpec.describe "stocks/edit", type: :view do
  before(:each) do
    @stock = assign(:stock, Stock.create!(
      :name => "MyString",
      :level => 1,
      :unit => "MyString",
      :estimate => false
    ))
  end

  it "renders the edit stock form" do
    render

    assert_select "form[action=?][method=?]", stock_path(@stock), "post" do

      assert_select "input#stock_name[name=?]", "stock[name]"

      assert_select "input#stock_level[name=?]", "stock[level]"

      assert_select "input#stock_unit[name=?]", "stock[unit]"
    end
  end
end
