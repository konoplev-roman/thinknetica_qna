# frozen_string_literal: true

require 'rails_helper'

feature 'User can answer the question', %(
  In order to help the community
  As an authenticated user
  I'd like to be able to answer the question
) do
  given(:question) { create(:question) }

  describe 'Authenticated user' do
    given(:user) { create(:user) }

    background do
      login(user)

      visit question_path(question)
    end

    scenario 'answer the question' do
      fill_in 'Answer', with: 'Content of the answer'

      click_on 'Post Your Answer'

      expect(page).to have_content 'Your answer has been published successfully!'

      expect(page).to have_content 'Content of the answer'

      expect(page).to have_current_path(question_path(question))
    end

    scenario 'answer the question with errors' do
      click_on 'Post Your Answer'

      expect(page).to have_content 'Answer can\'t be blank'
    end
  end

  describe 'Unauthenticated user' do
    background { visit question_path(question) }

    scenario 'tries to answer the question' do
      expect(page).to have_no_field 'Answer'

      expect(page).to have_no_content 'Post Your Answer'
    end
  end
end
