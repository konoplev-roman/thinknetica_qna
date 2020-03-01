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

    scenario 'can delete their answer' do
      create(:answer, user: user, question: question, body: 'Content of the my answer')

      visit question_path(question)

      within '.card' do
        click_on 'Delete'
      end

      expect(page).to have_content 'Your answer successfully removed!'

      expect(page).to have_current_path(question_path(question))

      expect(page).to have_no_content 'Content of the my answer'
    end

    scenario 'does not see the link to delete someone else\'s answer' do
      create(:answer, question: question)

      visit question_path(question)

      within '.card' do
        expect(page).to have_no_content 'Delete'
      end
    end
  end

  describe 'Guest' do
    scenario 'does not see the link to delete a answer' do
      create(:answer, question: question)

      visit question_path(question)

      within '.card' do
        expect(page).to have_no_content 'Delete'
      end
    end
  end
end
