require 'rails_helper'

RSpec.feature 'Stock management', type: :feature do
  context 'User not authenticated' do
    scenario "User can't see New Stock page" do
      visit '/stocks/new'
      expect(page).to have_text('You need to sign in or sign up before continuing')
    end
    scenario "User can't see Stock List page" do
      visit '/stocks'
      expect(page).to have_text('You need to sign in or sign up before continuing')
    end
  end

  context 'User authenticated' do
    before(:each) do
      fill_in_sign_in_form
    end

    scenario 'Create new stock' do
      visit '/stocks/new'
      fill_in 'Name', with: 'Beans'
      fill_in 'Unit', with: 'Grams'
      fill_in 'Level', with: '5000'
      click_button 'Save'
      expect(page).to have_text('Stock was successfully created')
    end

    scenario 'Omit name' do
      visit '/stocks/new'
      fill_in 'Name', with: ''
      fill_in 'Unit', with: 'Grams'
      fill_in 'Level', with: '5000'
      click_button 'Save'
      expect(page).to have_text("Name can't be blank")
    end

    scenario 'Omit unit' do
      visit '/stocks/new'
      fill_in 'Name', with: 'Beans'
      fill_in 'Unit', with: ''
      fill_in 'Level', with: 'NaN'
      click_button 'Save'
      expect(page).to have_text("Unit can't be blank")
    end

    scenario 'Omit level' do
      visit '/stocks/new'
      fill_in 'Name', with: 'Beans'
      fill_in 'Unit', with: ''
      fill_in 'Level', with: ''
      click_button 'Save'
      expect(page).to have_text("Level can't be blank")
    end

    scenario 'Negative level' do
      visit '/stocks/new'
      fill_in 'Name', with: 'Beans'
      fill_in 'Unit', with: 'Grams'
      fill_in 'Level', with: '-5'
      click_button 'Save'
      expect(page).to have_text('Level must be greater than or equal to 0')
    end

    scenario 'Invalid level' do
      visit '/stocks/new'
      fill_in 'Name', with: 'Beans'
      fill_in 'Unit', with: 'Grams'
      fill_in 'Level', with: 'NaN'
      click_button 'Save'
      expect(page).to have_text('Level is not a number')
    end

    scenario 'View stock' do
      visit '/stocks/new'
      fill_in 'Name', with: 'Beans'
      fill_in 'Unit', with: 'Grams'
      fill_in 'Level', with: '5000'
      click_button 'Save'
      expect(page).to have_text('Beans')
      expect(page).to have_text('5000 Grams')
    end

    scenario 'Edit stock' do
      visit '/stocks/new'
      fill_in 'Name', with: 'Beans'
      fill_in 'Unit', with: 'Grams'
      fill_in 'Level', with: '5000'
      click_button 'Save'
      click_link 'Edit'
      fill_in 'Name', with: 'Decaf stuff'
      click_button 'Save'
      expect(page).to have_text('Stock was successfully updated')
      expect(page).to have_text('Decaf stuff')
    end

    scenario 'Delete stock' do
      visit '/stocks/new'
      fill_in 'Name', with: 'Beans'
      fill_in 'Unit', with: 'Grams'
      fill_in 'Level', with: '5000'
      click_button 'Save'
      visit '/stocks'
      click_link 'Destroy'
      expect(page).to have_text('Stock was successfully deleted')
      expect(page).not_to have_text('Beans')
    end
  end
end
