require "rails_helper"

RSpec.feature "Order management", :type => :feature do
  context "User not authenticated" do
    scenario "User can't see New Order page" do
      visit "/orders/new"
      expect(page).to have_text("You need to sign in or sign up before continuing")
    end  
    scenario "User can't see Order List page" do
      visit "/orders"
      expect(page).to have_text("You need to sign in or sign up before continuing")
    end      
  end
  
  context "User authenticated" do
    before(:each) do
      fill_in_sign_in_form
      @line_item = create :line_item
    end
    
    scenario "Create new order" do
      visit "/orders/new"
      fill_in "Quantity", with: "2"
      click_button "Save"
      expect(page).to have_text("Order was successfully created")
    end
    
    scenario "Omit quantity" do
      visit "/orders/new"
      fill_in "Quantity", with: ""
      click_button "Save"
      expect(page).to have_text("Total selected items must be greater than 0")
    end
    
    scenario "Order total visible" do
      visit "/orders/new"
      fill_in "Quantity", with: "2"
      click_button "Save"
      expect(page).to have_text("$#{(@line_item.price_at_purchase * 2).to_s}")
    end
    
    scenario "Edit order" do
      visit "/orders/new"
      fill_in "Quantity", with: "2"
      click_button "Save"
      click_link "Edit"
      fill_in "Quantity", with: "3"
      click_button "Save"
      expect(page).to have_text("Order was successfully updated")
      expect(page).to have_text("$#{(@line_item.price_at_purchase * 3).to_s}")
    end
    
    scenario "Delete item" do
      visit "/orders/new"
      fill_in "Quantity", with: "2"
      click_button "Save"
      visit "/orders"
      click_link "Destroy"
      expect(page).to have_text("Order was successfully destroyed")
    end
    
    scenario "Orders paginated" do
      item = create :item
      50.times do
        Order.create!(line_items_attributes:[{item_id: item.id, quantity: 2}])
      end
      visit "/orders/"
      expect(page).to have_link("2")
    end
    

    
    context "Effects on stock" do
      let(:stock_effect) {create :stock_effect, item: @line_item.item}
      let(:stock) {stock_effect.stock}
      
      before(:each) do
        @old_level = stock.level
        visit "/orders/new"
        fill_in "Quantity", with: "2"
        click_button "Save"
      end
    
      scenario "New order decreases stock" do
        visit stock_path(stock)
        expect(page).to have_text(@old_level - (2*stock_effect.change))
        expect(page).to have_text("estimate")
      end
    
      scenario "Deleting order returns stock" do
        visit "/orders"
        click_link "Destroy"
        visit stock_path(stock)
        expect(page).to have_text(@old_level)
        expect(page).to have_text("estimate")
      end
    
      scenario "Adding to order decreases stock further" do
        click_link "Edit"
        fill_in "Quantity", with: "3"
        click_button "Save"
        visit stock_path(stock)
        expect(page).to have_text(@old_level - (3*stock_effect.change))
        expect(page).to have_text("estimate")
      end
    
      scenario "Subtracting from order restores stock" do
        click_link "Edit"
        fill_in "Quantity", with: "1"
        click_button "Save"
        visit stock_path(stock)
        expect(page).to have_text(@old_level - (1*stock_effect.change))
        expect(page).to have_text("estimate")
      end
    end
    
  end
  
  
end