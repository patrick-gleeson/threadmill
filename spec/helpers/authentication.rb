module Authentication
  def fill_in_sign_in_form
    user = create :user
    visit "/"
    fill_in "Email", with: user.email
    fill_in "Password", with: user.password
    click_button "Log in"
  end
end