# frozen_string_literal: true

require 'rails_helper'

feature 'User can view the list of questions', %(
  In order to help other users
  I'd like to be able to view the list of questions
) do
  describe 'When there are no questions' do
    scenario 'user sees a prompt to ask their question' do
      visit questions_path

      expect(page).to have_content 'No questions yet. Maybe you have something to ask?'
    end
  end

  describe 'When questions exist' do
    given!(:question1) { create(:question, title: 'Title of the first question', body: 'Body of the first question') }
    given!(:question2) { create(:question, title: 'Title of the second question', body: 'Body of the second question') }

    scenario 'user can view a list of questions' do
      visit questions_path

      expect(page).to have_no_content 'No questions yet. Maybe you have something to ask?'

      within '.card:nth-child(1)' do
        expect(page).to have_link 'Title of the first question', href: question_path(question1)
        expect(page).to have_content 'Body of the first question'
      end

      within '.card:nth-child(2)' do
        expect(page).to have_link 'Title of the second question', href: question_path(question2)
        expect(page).to have_content 'Body of the second question'
      end

      expect(page).to have_css('.card', count: 2)
    end
  end
end
