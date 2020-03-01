# frozen_string_literal: true

require 'rails_helper'

feature 'User can logout', %(
  In order to end the use session service
  As an authorized user
  I'd like to be able to logout
) do
  given(:user) { create(:user) }

  scenario 'Authorized user can logout' do
    login(user)

    click_on 'Logout'

    expect(page).to have_current_path(root_path)

    expect(page).to have_content 'Signed out successfully.'
    expect(page).to have_content 'Login'
  end

  scenario 'Guest does not see the logout link' do
    visit root_path

    expect(page).to have_no_content 'Logout'
  end
end
