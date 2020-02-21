# frozen_string_literal: true

require 'rails_helper'

feature 'User can delete answer', %(
  In order to remove irrelevant information
  As an authenticated author
  I'd like to be able to remove my answers
) do
  given(:question) { create(:question) }

  describe 'Authenticated user' do
    given(:user) { create(:user) }

    background { login(user) }

    scenario 'remove own answer' do
      create(:answer, user: user, question: question, body: 'Content of the my answer')

      visit question_path(question)

      click_on 'Delete'

      expect(page).to have_content 'Your answer successfully removed!'

      expect(page).to have_current_path(question_path(question))

      expect(page).to have_no_content 'Content of the my answer'
    end

    scenario 'tries to remove someone else\'s answer' do
      create(:answer, question: question)

      visit question_path(question)

      expect(page).to have_no_content 'Delete'
    end
  end

  describe 'Unauthenticated user' do
    scenario 'tries to remove someone else\'s answer' do
      create(:answer, question: question)

      visit question_path(question)

      expect(page).to have_no_content 'Delete'
    end
  end
end
