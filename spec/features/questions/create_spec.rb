# frozen_string_literal: true

require 'rails_helper'

feature 'User can create question', %(
  In order to get answer from a community
  As an authenticated user
  I'd like to be able to ask the question
) do
  describe 'Authenticated user' do
    given(:user) { create(:user) }

    background { login(user) }

    scenario 'can use the link to ask a question' do
      visit questions_path

      click_on 'Ask question'

      expect(page).to have_current_path(new_question_path)
    end

    scenario 'can ask a question with valid attributes' do
      visit new_question_path

      fill_in 'Title', with: 'Title of the question'
      fill_in 'Body', with: 'Content of the question'

      click_on 'Ask'

      expect(page).to have_current_path(%r{questions/\d+})

      expect(page).to have_content 'Your question successfully created!'

      expect(page).to have_content 'Title of the question'
      expect(page).to have_content 'Content of the question'
    end

    scenario 'can attach a file by asking a question' do
      visit new_question_path

      fill_in 'Title', with: 'Title of the question'
      fill_in 'Body', with: 'Content of the question'

      attach_file 'Attach files', [Rails.root.join('spec/rails_helper.rb'), Rails.root.join('spec/spec_helper.rb')]

      click_on 'Ask'

      expect(page).to have_content 'rails_helper.rb'
      expect(page).to have_content 'spec_helper.rb'
    end

    describe 'cannot ask a question' do
      background { visit new_question_path }

      scenario 'without filling in the title field' do
        fill_in 'Body', with: 'Content of the question'

        click_on 'Ask'

        expect(page).to have_current_path(questions_path)

        expect(page).to have_content 'Title can\'t be blank'
      end

      scenario 'without filling in the body field' do
        fill_in 'Title', with: 'Title of the question'

        click_on 'Ask'

        expect(page).to have_current_path(questions_path)

        expect(page).to have_content 'Body can\'t be blank'
      end
    end
  end

  describe 'Guest' do
    scenario 'does not see the link to ask a question' do
      visit questions_path

      expect(page).to have_no_content 'Ask question'
    end

    scenario 'cannot ask question' do
      visit new_question_path

      expect(page).to have_content 'You need to sign in or sign up before continuing.'

      # Checking for a ask question form
      expect(page).to have_no_field 'Title'
      expect(page).to have_no_field 'Body'

      # Checking for a login form
      expect(page).to have_field 'Email'
    end
  end
end
