# frozen_string_literal: true

require 'rails_helper'

feature 'User can edit question', %(
  In order to clarify or correct errors
  As an authenticated user
  I'd like to be able to edit my questions
) do
  given(:user) { create(:user) }
  given!(:their_question) { create(:question, user: user, title: 'Title of the my question') }
  given!(:other_question) { create(:question, title: 'Title of someone else\'s question') }

  describe 'Authenticated user' do
    background do
      login(user)

      visit question_path(their_question)
    end

    scenario 'can edit their question with valid attributes', js: true do
      within '.question' do
        click_on 'Edit'
      end

      within '.edit-question' do
        fill_in 'Title', with: 'New title of the my question'
        fill_in 'Body', with: 'New body'

        click_on 'Save'
      end

      expect(page).to have_no_content 'Title of the my question'
      expect(page).to have_no_content 'MyText'

      expect(page).to have_content 'New title of the my question'
      expect(page).to have_content 'New body'

      expect(page).to have_no_field 'Title'
      expect(page).to have_no_field 'Body'

      expect(page).to have_content 'Your question successfully updated!'
    end

    describe 'cannot edit their question' do
      scenario 'without filling in the title field', js: true do
        within '.question' do
          click_on 'Edit'
        end

        within '.edit-question' do
          fill_in 'Title', with: ''
          fill_in 'Body', with: 'New body'

          click_on 'Save'
        end

        expect(page).to have_content 'Title can\'t be blank'
      end

      scenario 'without filling in the body field', js: true do
        within '.question' do
          click_on 'Edit'
        end

        within '.edit-question' do
          fill_in 'Title', with: 'New title of the my question'
          fill_in 'Body', with: ''

          click_on 'Save'
        end

        expect(page).to have_content 'Body can\'t be blank'
      end
    end

    scenario 'does not see the link to edit someone else\'s question' do
      visit question_path(other_question)

      within '.question' do
        expect(page).to have_no_content 'Edit'
      end
    end
  end

  describe 'Guest' do
    scenario 'does not see the link to edit question' do
      visit question_path(other_question)

      within '.question' do
        expect(page).to have_no_content 'Edit'
      end
    end
  end
end
