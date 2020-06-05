# frozen_string_literal: true

require 'rails_helper'

feature 'User can register', %(
  In order to use the service
  As an unauthenticated user
  I'd like to be able to register
) do
  describe 'Guest', :without_auth do
    scenario 'can use the registration link' do
      visit root_path

      click_on 'Signup'

      expect(page).to have_current_path(new_user_registration_path)
    end

    scenario 'can use the return back link' do
      visit new_user_registration_path

      click_on 'Back'

      expect(page).to have_current_path(root_path)
    end

    scenario 'can register with valid attributes' do
      visit new_user_registration_path

      fill_in 'Email', with: 'user@example.com'
      fill_in 'Password', with: '12345678'
      fill_in 'Password confirmation', with: '12345678'

      click_on 'Sign up'

      expect(page).to have_current_path(root_path)

      expect(page).to have_content 'Welcome! You have signed up successfully.'
      expect(page).to have_no_content 'Signup'
    end

    describe 'cannot register' do
      background { visit new_user_registration_path }

      scenario 'without filling in the login field' do
        fill_in 'Password', with: '12345678'

        click_on 'Sign up'

        expect(page).to have_content 'Email can\'t be blank'

        expect(page).to have_current_path(user_registration_path)
      end

      scenario 'without filling in the password field' do
        fill_in 'Email', with: 'wrong@example.com'

        click_on 'Sign up'

        expect(page).to have_content 'Password can\'t be blank'

        expect(page).to have_current_path(user_registration_path)
      end

      scenario 'with a different password confirmation' do
        fill_in 'Email', with: 'wrong@example.com'
        fill_in 'Password', with: '12345678'
        fill_in 'Password', with: '87654321'

        click_on 'Sign up'

        expect(page).to have_content 'Password confirmation doesn\'t match Password'

        expect(page).to have_current_path(user_registration_path)
      end

      scenario 'with a short password' do
        fill_in 'Password', with: '123'

        click_on 'Sign up'

        expect(page).to have_content 'Password is too short (minimum is 6 characters)'

        expect(page).to have_current_path(user_registration_path)
      end

      scenario 'with an already used email' do
        fill_in 'Email', with: user.email

        click_on 'Sign up'

        expect(page).to have_content 'Email has already been taken'

        expect(page).to have_current_path(user_registration_path)
      end
    end
  end

  describe 'Authenticated user' do
    scenario 'does not see the registration link' do
      visit root_path

      expect(page).to have_no_content 'Signup'
    end

    scenario 'cannot register' do
      visit new_user_registration_path

      expect(page).to have_current_path(root_path)

      expect(page).to have_content 'You are already signed in.'
    end
  end
end
