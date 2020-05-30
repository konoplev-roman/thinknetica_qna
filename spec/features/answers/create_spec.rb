# frozen_string_literal: true

require 'rails_helper'

feature 'User can answer the question', %(
  In order to help the community
  As an authenticated user
  I'd like to be able to answer the question
) do
  given(:question) { create(:question) }

  scenario 'can answer the question with valid attributes', js: true do
    visit question_path(question)

    within '.new-answer' do
      fill_in 'Answer', with: 'Content of the answer'

      click_on 'Post Your Answer'
    end

    expect(page).to have_current_path(question_path(question))

    expect(page).to have_content 'Your answer has been published successfully!'

    within '.card' do
      expect(page).to have_content 'Content of the answer'
    end

    expect(page).to have_css('.card', count: 1)
  end

  describe 'cannot answer the question' do
    scenario 'without filling in the answer field', js: true do
      visit question_path(question)

      within '.new-answer' do
        click_on 'Post Your Answer'
      end

      expect(page).to have_content 'Answer can\'t be blank'

      expect(page).to have_css('.card', count: 0)
    end
  end

  describe 'Guest', :without_auth do
    scenario 'does not see the link to answer the question' do
      visit question_path(question)

      within '.new-answer' do
        expect(page).to have_no_content 'Post Your Answer'
      end
    end
  end
end
