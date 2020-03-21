# frozen_string_literal: true

require 'rails_helper'

feature 'User can edit answer', %(
  In order to clarify or correct errors
  As an authenticated user
  I'd like to be able to edit my answers
) do
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given!(:their_answer) { create(:answer, question: question, user: user, body: 'Content of the my answer') }
  given!(:other_answer) { create(:answer, question: question, body: 'Content of someone else\'s answer') }

  describe 'Authenticated user' do
    background do
      login(user)

      visit question_path(question)
    end

    scenario 'can edit their answer with valid attributes', js: true do
      within "#answer-#{their_answer.id}" do
        click_on 'Edit'

        fill_in 'Answer', with: 'New content of the my answer'

        click_on 'Save'

        expect(page).to have_no_content 'Old content of the my answer'
        expect(page).to have_content 'New content of the my answer'

        expect(page).to have_no_field 'Answer'
      end

      expect(page).to have_content 'Your answer successfully updated!'
    end

    describe 'with files' do
      given!(:their_answer_with_files) { create(:answer, :with_files, question: question, user: user) }

      background { visit question_path(question) }

      scenario 'can attach a file to their answer', js: true do
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
      end

      scenario 'can delete a file from their answer', js: true do
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

    scenario 'cannot edit their question without filling in the answer field', js: true do
      within "#answer-#{their_answer.id}" do
        click_on 'Edit'

        fill_in 'Answer', with: ''

        click_on 'Save'
      end

      expect(page).to have_content 'Answer can\'t be blank'
    end

    scenario 'does not see the link to edit someone else\'s answer' do
      within "#answer-#{other_answer.id}" do
        expect(page).to have_no_content 'Edit'
      end
    end
  end

  describe 'Guest' do
    scenario 'does not see the link to edit answer' do
      visit question_path(question)

      within '.answers' do
        expect(page).to have_no_content 'Edit'
      end
    end
  end
end
