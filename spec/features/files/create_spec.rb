# frozen_string_literal: true

require 'rails_helper'

feature 'User can add files', %(
  In order to add information to a question or answer
  As an authenticated user
  I'd like to be able to add files to my question or answer
) do
  given(:question) { create(:question) }

  scenario 'can add files to a question' do
    visit new_question_path

    within '.edit-question' do
      fill_in 'Title', with: 'Title of the question'
      fill_in 'Body', with: 'Content of the question'
    end

    attach_file 'Attach files', [Rails.root.join('spec/rails_helper.rb'), Rails.root.join('spec/spec_helper.rb')]

    click_on 'Ask'

    expect(page).to have_content 'Your question successfully created!'

    expect(page).to have_content 'rails_helper.rb'
    expect(page).to have_content 'spec_helper.rb'
  end

  scenario 'can add files to a answer', js: true do
    visit question_path(question)

    within '.new-answer' do
      fill_in 'Answer', with: 'Content of the answer'

      attach_file 'Attach files', \
                  [Rails.root.join('spec/rails_helper.rb'), Rails.root.join('spec/spec_helper.rb')], \
                  visible: false

      click_on 'Post Your Answer'
    end

    expect(page).to have_content 'Your answer has been published successfully!'

    within '.answer' do
      expect(page).to have_content 'rails_helper.rb'
      expect(page).to have_content 'spec_helper.rb'
    end
  end
end
