# frozen_string_literal: true

require 'rails_helper'

feature 'User can delete award for best answer', %(
  In order to delete the reward for helping solve my problem
  As an authenticated user
  I'd like to be able to delete the award for the best answer to my question
) do
  given!(:their_question_with_award) { create(:question, :with_award, user: user) }

  scenario 'can delete award for best answer by editing the question', js: true do
    visit question_path(their_question_with_award)

    within '.question' do
      click_on 'Edit'
    end

    within '.award' do
      accept_alert { click_on 'Delete' }
    end

    within '.question' do
      click_on 'Save'
    end

    expect(page).to have_content 'Your question successfully updated!'

    expect(page).to have_no_content 'Cool!'
    expect(page).to have_no_css("img[src*='thumb-up.png']")
  end
end
