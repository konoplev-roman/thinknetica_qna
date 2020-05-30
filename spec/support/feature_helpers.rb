# frozen_string_literal: true

module FeatureHelpers
  def login(user)
    visit new_user_session_path

    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password

    click_on 'Log in'
  end

  def sign_out(_user)
    click_on 'Logout'
  end
end
