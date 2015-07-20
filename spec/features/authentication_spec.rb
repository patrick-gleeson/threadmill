require 'rails_helper'

RSpec.feature 'Authentication', type: :feature do
  scenario 'User prompted to log in' do
    visit '/'
    expect(page).to have_text('You need to sign in or sign up before continuing')
    expect(page).not_to have_text('Create an order')
  end

  scenario 'User logs in' do
    user = create :user
    visit '/'
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_button 'Log in'
    expect(page).to have_text('Create an order')
  end

  scenario 'Incorrect email' do
    user = create :user
    visit '/'
    fill_in 'Email', with: 'some@email.address'
    fill_in 'Password', with: user.password
    click_button 'Log in'
    expect(page).to have_text('Invalid email or password')
  end

  scenario 'Incorrect password' do
    user = create :user
    visit '/'
    fill_in 'Email', with: user.email
    fill_in 'Password', with: 'n0t my password'
    click_button 'Log in'
    expect(page).to have_text('Invalid email or password')
  end
end
