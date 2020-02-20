# frozen_string_literal: true

require 'rails_helper'

feature 'User can register', %(
  In order to use the service
  As an unauthenticated user
  I'd like to be able to register
) do
  background { visit new_user_registration_path }

  scenario 'User tries to register' do
    fill_in 'Email', with: 'user@example.com'
    fill_in 'Password', with: '12345678'
    fill_in 'Password confirmation', with: '12345678'

    click_on 'Sign up'

    expect(page).to have_content 'Welcome! You have signed up successfully.'
  end

  scenario 'User tries to register with errors' do
    fill_in 'Email', with: 'wrong@example.com'

    click_on 'Sign up'

    expect(page).to have_content 'Password can\'t be blank'
  end
end
