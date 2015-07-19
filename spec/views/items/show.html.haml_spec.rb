require 'rails_helper'

RSpec.describe "items/show", type: :view do
  before(:each) do
    @item = assign(:item, create(:item))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(Regexp.new @item.name)
    expect(rendered).to match(Regexp.new(Regexp.quote(@item.price.format)))
  end
end
