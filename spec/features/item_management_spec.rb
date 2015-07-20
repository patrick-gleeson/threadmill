require 'rails_helper'

RSpec.feature 'Item management', type: :feature do
  context 'User not authenticated' do
    scenario "User can't see New Item page" do
      visit '/items/new'
      expect(page).to have_text('You need to sign in or sign up before continuing')
    end
    scenario "User can't see Item List page" do
      visit '/items'
      expect(page).to have_text('You need to sign in or sign up before continuing')
    end
  end

  context 'User authenticated' do
    before(:each) do
      fill_in_sign_in_form
    end

    scenario 'Create new item' do
      visit '/items/new'
      fill_in 'Name', with: 'Pastry'
      fill_in 'Price ($)', with: '4.52'
      click_button 'Save'
      expect(page).to have_text('Item was successfully created')
    end

    scenario 'Omit name' do
      visit '/items/new'
      fill_in 'Name', with: ''
      fill_in 'Price ($)', with: '4.52'
      click_button 'Save'
      expect(page).to have_text("Name can't be blank")
    end

    scenario 'Invalid price' do
      visit '/items/new'
      fill_in 'Name', with: 'Pastry'
      fill_in 'Price ($)', with: '-53'
      click_button 'Save'
      expect(page).to have_text('Price cents must be greater than 0')
    end

    scenario 'View item' do
      visit '/items/new'
      fill_in 'Name', with: 'Pastry'
      fill_in 'Price ($)', with: '4.52'
      click_button 'Save'
      expect(page).to have_text('Pastry')
      expect(page).to have_text('$4.52')
    end

    scenario 'Edit item' do
      visit '/items/new'
      fill_in 'Name', with: 'Pastry'
      fill_in 'Price ($)', with: '4.52'
      click_button 'Save'
      click_link 'Edit'
      fill_in 'Name', with: 'Pain Au C'
      click_button 'Save'
      expect(page).to have_text('Item was successfully updated')
      expect(page).to have_text('Pain Au C')
    end

    scenario 'Delete item' do
      visit '/items/new'
      fill_in 'Name', with: 'Pastry'
      fill_in 'Price ($)', with: '4.52'
      click_button 'Save'
      visit '/items'
      click_link 'Remove'
      expect(page).to have_text('Item was successfully deleted')
      expect(page).not_to have_text('Pastry')
    end
  end
end
