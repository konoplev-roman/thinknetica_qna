# frozen_string_literal: true

require 'rails_helper'

feature 'User can see award for best answer', %(
  In order to see the reward for helping solve my problem
  As an authenticated user
  I'd like to be able to see the award for the best answer to my question
) do
  given(:their_question_with_award) { create(:question, :with_award, user: user) }
  given(:other_question_with_award) { create(:question, :with_award, user: john) }

  scenario 'can see award for best answer' do
    visit question_path(their_question_with_award)

    within '.question' do
      expect(page).to have_content 'Cool!'
      expect(page).to have_css("img[src*='star.png']")
    end
  end

  scenario 'does not see the award from someone else\'s question' do
    visit question_path(other_question_with_award)

    within '.question' do
      expect(page).to have_no_content 'Cool!'
      expect(page).to have_no_css("img[src*='star.png']")
    end
  end
end
