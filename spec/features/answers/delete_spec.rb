# frozen_string_literal: true

require 'rails_helper'

feature 'User can delete answer', %(
  In order to remove irrelevant information
  As an authenticated author
  I'd like to be able to remove my answers
) do
  given(:question) { create(:question) }
  given!(:their_answer) { create(:answer, user: user, question: question, body: 'Content of the my answer') }
  given!(:other_answer) { create(:answer, user: john, question: question, body: 'Content of someone else\'s answer') }

  background { visit question_path(question) }

  scenario 'can delete their answer', js: true do
    within "#answer-#{their_answer.id}" do
      accept_alert { click_on 'Delete' }
    end

    expect(page).to have_content 'Your answer successfully removed!'

    expect(page).to have_current_path(question_path(question))

    expect(page).to have_no_content 'Content of the my answer'

    expect(page).to have_content 'Content of someone else\'s answer'
  end

  scenario 'does not see the link to delete someone else\'s answer' do
    within "#answer-#{other_answer.id}" do
      expect(page).to have_no_content 'Delete'
    end
  end

  describe 'Guest', :without_auth do
    background { visit question_path(question) }

    scenario 'does not see the link to delete a answer' do
      within '.answers' do
        expect(page).to have_no_content 'Delete'
      end
    end
  end
end
