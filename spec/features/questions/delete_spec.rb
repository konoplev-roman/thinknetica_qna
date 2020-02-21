# frozen_string_literal: true

require 'rails_helper'

feature 'User can delete question', %(
  In order to remove irrelevant information
  As an authenticated author
  I'd like to be able to remove my questions
) do
  given(:question) { create(:question) }

  describe 'Authenticated user' do
    given(:user) { create(:user) }
    given(:own_question) { create(:question, user: user, title: 'Title of the my question') }

    background { login(user) }

    scenario 'remove own question' do
      visit question_path(own_question)

      click_on 'Delete'

      expect(page).to have_content 'Your question successfully removed!'

      expect(page).to have_current_path(questions_path)

      expect(page).to have_no_content 'Title of the my question'
    end

    scenario 'tries to remove someone else\'s question' do
      visit question_path(question)

      expect(page).to have_no_content 'Delete'
    end
  end

  describe 'Unauthenticated user' do
    scenario 'tries to remove someone else\'s question' do
      visit question_path(question)

      expect(page).to have_no_content 'Delete'
    end
  end
end
