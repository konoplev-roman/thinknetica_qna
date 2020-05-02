# frozen_string_literal: true

require 'rails_helper'

feature 'User can choose the best answer', %(
  In order to show that the answer helped me solve the question
  As an authenticated user
  I'd like to be able to choose one of the answers to my question as the best
) do
  given(:user) { create(:user) }
  given(:their_question) { create(:question, user: user) }
  given(:other_question) { create(:question) }

  background do
    create(:answer, question: their_question, body: 'New best answer')
    create(:answer, question: their_question, body: 'Old best answer').best!

    create(:answer, question: other_question)
  end

  describe 'Authenticated user' do
    background { login(user) }

    scenario 'can choose the best answer for their question', js: true do
      visit question_path(their_question)

      # Checking the original order of answers

      within '.answers .card:nth-child(1)' do
        expect(page).to have_content 'Old best answer'

        expect(page).to have_content 'The question author chose this as the best answer'
      end

      within '.answers .card:nth-child(2)' do
        expect(page).to have_content 'New best answer'

        expect(page).to have_no_content 'The question author chose this as the best answer'

        click_on 'Best'
      end

      # Checking that the best answer is displayed first

      within '.answers .card:nth-child(1)' do
        expect(page).to have_content 'New best answer'

        expect(page).to have_content 'The question author chose this as the best answer'
      end

      within '.answers .card:nth-child(2)' do
        expect(page).to have_content 'Old best answer'

        expect(page).to have_no_content 'The question author chose this as the best answer'
      end

      expect(page).to have_content 'You have successfully chosen the best answer!'
    end

    scenario 'does not see the link to choose the best answer for someone else\'s question' do
      visit question_path(other_question)

      within '.answers' do
        expect(page).to have_no_content 'Best'
      end
    end
  end

  describe 'Guest' do
    scenario 'does not see the link to choose the best answer' do
      visit question_path(other_question)

      within '.answers' do
        expect(page).to have_no_content 'Best'
      end
    end
  end
end
