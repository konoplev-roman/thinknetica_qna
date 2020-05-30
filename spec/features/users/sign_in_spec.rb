# frozen_string_literal: true

require 'rails_helper'

feature 'User can sign in', %(
  In order to use all the features of the service
  As an unauthenticated user
  I'd like to be able to sign in
) do
  describe 'Guest', :without_auth do
    scenario 'can use the login link' do
      visit root_path

      click_on 'Login'

      expect(page).to have_current_path(new_user_session_path)
    end

    scenario 'can use the return back link' do
      visit new_user_session_path

      click_on 'Back'

      expect(page).to have_current_path(root_path)
    end

    scenario 'can login with valid attributes' do
      login(user)

      expect(page).to have_current_path(root_path)

      expect(page).to have_content 'Signed in successfully.'
      expect(page).to have_no_content 'Login'
    end

    describe 'cannot login' do
      background { visit new_user_session_path }

      scenario 'without filling in the login field' do
        fill_in 'Password', with: user.password

        click_on 'Log in'

        expect(page).to have_current_path(user_session_path)

        expect(page).to have_content 'Invalid Email or password.'
      end

      scenario 'without filling in the password field' do
        fill_in 'Email', with: user.email

        click_on 'Log in'

        expect(page).to have_current_path(user_session_path)

        expect(page).to have_content 'Invalid Email or password.'
      end

      scenario 'with invalid username and password' do
        fill_in 'Email', with: user.email
        fill_in 'Password', with: 'wrong password'

        click_on 'Log in'

        expect(page).to have_current_path(user_session_path)

        expect(page).to have_content 'Invalid Email or password.'
      end
    end
  end

  describe 'Authenticated user' do
    scenario 'does not see the login link' do
      visit root_path

      expect(page).to have_no_content 'Login'
    end

    scenario 'cannot login' do
      visit new_user_session_path

      expect(page).to have_current_path(root_path)

      expect(page).to have_content 'You are already signed in.'
    end
  end
end
