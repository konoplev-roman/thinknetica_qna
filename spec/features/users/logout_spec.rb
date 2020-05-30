# frozen_string_literal: true

require 'rails_helper'

feature 'User can logout', %(
  In order to end the use session service
  As an authorized user
  I'd like to be able to logout
) do
  scenario 'Authorized user can logout' do
    sign_out(user)

    expect(page).to have_current_path(root_path)

    expect(page).to have_content 'Signed out successfully.'
    expect(page).to have_content 'Login'
  end

  scenario 'Guest does not see the logout link', :without_auth do
    visit root_path

    expect(page).to have_no_content 'Logout'
  end
end
