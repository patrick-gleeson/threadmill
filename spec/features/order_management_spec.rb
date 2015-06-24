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
      expect(page).to have_text("$#{(@line_item.price_at_purchase * 0.02).to_s}")
    end
    
    scenario "Edit order" do
      visit "/orders/new"
      fill_in "Quantity", with: "2"
      click_button "Save"
      click_link "Edit"
      fill_in "Quantity", with: "3"
      click_button "Save"
      expect(page).to have_text("Order was successfully updated")
      expect(page).to have_text("$#{(@line_item.price_at_purchase * 0.03).to_s}")
    end
    
    scenario "Delete item" do
      visit "/orders/new"
      fill_in "Quantity", with: "2"
      click_button "Save"
      visit "/orders"
      click_link "Destroy"
      expect(page).to have_text("Order was successfully destroyed")
    end
    
  end
  
  
end