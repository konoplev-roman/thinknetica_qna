# frozen_string_literal: true

require 'rails_helper'

feature 'User can edit award for best answer', %(
  In order to change the reward for helping solve my problem
  As an authenticated user
  I'd like to be able to change the award for the best answer to my question
) do
  given!(:their_question_with_award) { create(:question, :with_award, user: user) }

  background do
    visit question_path(their_question_with_award)

    within '.question' do
      click_on 'Edit'
    end
  end

  scenario 'can change award for best answer by editing the question', js: true do
    within '.award' do
      fill_in 'Award title', with: 'Best!'

      attach_file 'Attach image', Rails.root.join('spec/factories/images/star.png'), visible: false
    end

    within '.question' do
      click_on 'Save'
    end

    expect(page).to have_content 'Your question successfully updated!'

    expect(page).to have_no_content 'Cool!'
    expect(page).to have_no_css("img[src*='thumb-up.png']")

    expect(page).to have_content 'Best!'
    expect(page).to have_css("img[src*='star.png']")
  end

  describe 'cannot change award for best answer by editing the question' do
    scenario 'without filling in the title of the award', js: true do
      within '.award' do
        fill_in 'Award title', with: ''

        attach_file 'Attach image', Rails.root.join('spec/factories/images/thumb-up.png'), visible: false
      end

      within '.question' do
        click_on 'Save'
      end

      expect(page).to have_content 'Award title can\'t be blank'
    end

    scenario 'without filling in the image of the award', js: true do
      within '.award' do
        accept_alert { click_on 'Delete' }

        fill_in 'Award title', with: 'Best!'
      end

      within '.question' do
        click_on 'Save'
      end

      expect(page).to have_content 'Award image can\'t be blank'
    end

    scenario 'with invalid image of the award', js: true do
      within '.award' do
        accept_alert { click_on 'Delete' }

        fill_in 'Award title', with: 'Cool!'

        attach_file 'Attach image', Rails.root.join('spec/rails_helper.rb'), visible: false
      end

      within '.question' do
        click_on 'Save'
      end

      expect(page).to have_content 'Award image has an invalid content type'
    end
  end
end
