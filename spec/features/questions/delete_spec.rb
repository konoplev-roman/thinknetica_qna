# frozen_string_literal: true

require 'rails_helper'

feature 'User can delete question', %(
  In order to remove irrelevant information
  As an authenticated author
  I'd like to be able to remove my questions
) do
  given!(:their_question) { create(:question, user: user, title: 'Title of the my question') }
  given!(:other_question) { create(:question, user: john, title: 'Title of someone else\'s question') }

  scenario 'can delete their question' do
    visit question_path(their_question)

    within '.show-question' do
      click_on 'Delete'
    end

    expect(page).to have_content 'Your question successfully removed!'

    expect(page).to have_current_path(questions_path)

    expect(page).to have_no_content 'Title of the my question'

    expect(page).to have_content 'Title of someone else\'s question'
  end

  scenario 'does not see the link to delete someone else\'s question' do
    visit question_path(other_question)

    within '.show-question' do
      expect(page).to have_no_content 'Delete'
    end
  end

  describe 'Guest', :without_auth do
    scenario 'does not see the link to delete a question' do
      visit question_path(other_question)

      within '.show-question' do
        expect(page).to have_no_content 'Delete'
      end
    end
  end
end
