require 'rails_helper'

RSpec.describe "home/index", type: :view do
  it "gives some basic options" do
    render
    expect(rendered).to match(/Create an order/)
    expect(rendered).to match(/Check stock/)
    expect(rendered).to match(/Configure items for sale/)
  end
end
