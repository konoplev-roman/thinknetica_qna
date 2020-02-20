# frozen_string_literal: true

require 'rails_helper'

feature 'User can logout', %(
  In order to end the use session service
  As an authorized user
  I'd like to be able to logout
) do
  given(:user) { create(:user) }

  background { login(user) }

  scenario 'Authorized user tries to logout' do
    click_on 'Logout'

    expect(page).to have_content 'Signed out successfully.'
  end
end
