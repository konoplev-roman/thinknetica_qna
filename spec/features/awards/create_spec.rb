# frozen_string_literal: true

require 'rails_helper'

feature 'User can add award for best answer', %(
  In order to reward for helping solve my problem
  As an authenticated user
  I'd like to be able to add an award for the best answer to my question
) do
  background do
    visit new_question_path

    within '.edit-question' do
      fill_in 'Title', with: 'Title of the question'
      fill_in 'Body', with: 'Content of the question'
    end
  end

  scenario 'can add award for best answer by asking a question' do
    within '.award' do
      fill_in 'Award title', with: 'Cool!'

      attach_file 'Attach image', Rails.root.join('spec/factories/images/thumb-up.png'), visible: false
    end

    click_on 'Ask'

    expect(page).to have_content 'Your question successfully created!'

    expect(page).to have_content 'Cool!'
    expect(page).to have_css("img[src*='thumb-up.png']")
  end

  describe 'cannot add award for best answer by asking a question' do
    scenario 'without filling in the title of the award', js: true do
      within '.award' do
        attach_file 'Attach image', Rails.root.join('spec/factories/images/thumb-up.png'), visible: false
      end

      click_on 'Ask'

      expect(page).to have_content 'Award title can\'t be blank'
    end

    scenario 'without filling in the image of the award', js: true do
      within '.award' do
        fill_in 'Award title', with: 'Cool!'
      end

      click_on 'Ask'

      expect(page).to have_content 'Award image can\'t be blank'
    end

    scenario 'with invalid image of the award', js: true do
      within '.award' do
        fill_in 'Award title', with: 'Cool!'
        attach_file 'Attach image', Rails.root.join('spec/rails_helper.rb'), visible: false
      end

      click_on 'Ask'

      expect(page).to have_content 'Award image has an invalid content type'
    end
  end
end
