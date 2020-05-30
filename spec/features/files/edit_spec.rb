# frozen_string_literal: true

require 'rails_helper'

feature 'User can edit files', %(
  In order to change the question or answer information
  As an authenticated user
  I'd like to be able to edit files from my question or answer
) do
  given!(:their_question_with_files) { create(:question, :with_files, user: user) }
  given!(:their_answer_with_files) { create(:answer, :with_files, user: user) }

  scenario 'can edit files from the question', js: true do
    visit question_path(their_question_with_files)

    within '.question' do
      click_on 'Edit'
    end

    within '.edit-question' do
      attach_file 'Attach files', Rails.root.join('.rspec'), visible: false

      click_on 'Save'
    end

    expect(page).to have_content 'Your question successfully updated!'

    # these files were added earlier and should be saved
    expect(page).to have_content 'rails_helper.rb'
    expect(page).to have_content 'spec_helper.rb'

    # new file
    expect(page).to have_content '.rspec'
  end

  scenario 'can edit files from the answer', js: true do
    visit question_path(their_answer_with_files.question)

    within "#answer-#{their_answer_with_files.id}" do
      click_on 'Edit'

      attach_file 'Attach files', Rails.root.join('.rspec'), visible: false

      click_on 'Save'

      # these files were added earlier and should be saved
      expect(page).to have_content 'rails_helper.rb'
      expect(page).to have_content 'spec_helper.rb'

      # new file
      expect(page).to have_content '.rspec'
    end

    expect(page).to have_content 'Your answer successfully updated!'
  end
end
