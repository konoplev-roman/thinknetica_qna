# frozen_string_literal: true

require 'rails_helper'

feature 'User can delete files', %(
  In order to delete the question or answer information
  As an authenticated user
  I'd like to be able to delete files from my question or answer
) do
  given!(:their_question_with_files) { create(:question, :with_files, user: user) }
  given!(:their_answer_with_files) { create(:answer, :with_files, user: user) }

  scenario 'can delete files from the question', js: true do
    visit question_path(their_question_with_files)

    within '.question' do
      click_on 'Edit'
    end

    within '.edit-question .file', text: 'rails_helper.rb' do
      accept_alert { click_on 'Delete' }
    end

    # this file was added earlier and should be saved
    expect(page).to have_content 'spec_helper.rb'

    # deleted file
    expect(page).to have_no_content 'rails_helper.rb'

    expect(page).to have_content 'Your file successfully removed!'
  end

  scenario 'can delete files from the answer', js: true do
    visit question_path(their_answer_with_files.question)

    within "#answer-#{their_answer_with_files.id}" do
      click_on 'Edit'

      within '.edit-answer .file', text: 'rails_helper.rb' do
        accept_alert { click_on 'Delete' }
      end

      # this file was added earlier and should be saved
      expect(page).to have_content 'spec_helper.rb'

      # deleted file
      expect(page).to have_no_content 'rails_helper.rb'
    end

    expect(page).to have_content 'Your file successfully removed!'
  end
end
