# frozen_string_literal: true

require 'rails_helper'

feature 'User can edit question', %(
  In order to clarify or correct errors
  As an authenticated user
  I'd like to be able to edit my questions
) do
  given(:user) { create(:user) }
  given!(:their_question) { create(:question, user: user, title: 'Title of the my question') }
  given!(:other_question) { create(:question, title: 'Title of someone else\'s question') }

  describe 'Authenticated user' do
    background do
      login(user)

      visit question_path(their_question)
    end

    scenario 'can edit their question with valid attributes', js: true do
      within '.question' do
        click_on 'Edit'
      end

      within '.edit-question' do
        fill_in 'Title', with: 'New title of the my question'
        fill_in 'Body', with: 'New body'

        click_on 'Save'
      end

      expect(page).to have_no_content 'Title of the my question'
      expect(page).to have_no_content 'MyText'

      expect(page).to have_content 'New title of the my question'
      expect(page).to have_content 'New body'

      expect(page).to have_no_field 'Title'
      expect(page).to have_no_field 'Body'

      expect(page).to have_content 'Your question successfully updated!'
    end

    describe 'with files' do
      given!(:their_question_with_files) { create(:question, :with_files, user: user) }

      background { visit question_path(their_question_with_files) }

      scenario 'can attach a file to their question', js: true do
        within '.question' do
          click_on 'Edit'
        end

        within '.edit-question' do
          attach_file 'Attach files', Rails.root.join('.rspec'), visible: false

          click_on 'Save'
        end

        # these files were added earlier and should be saved
        expect(page).to have_content 'rails_helper.rb'
        expect(page).to have_content 'spec_helper.rb'

        # new file
        expect(page).to have_content '.rspec'
      end

      scenario 'can delete a file from their question', js: true do
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
    end

    describe 'with links' do
      given!(:their_question_with_links) { create(:question, user: user) }
      given!(:link) { create(:link, linkable: their_question_with_links) }
      given(:google_url) { 'http://google.com/' }

      background { visit question_path(their_question_with_links) }

      scenario 'can add links to their question', js: true do
        within '.question' do
          click_on 'Edit'
        end

        within '.edit-question' do
          click_on 'Add link'
        end

        # 3 index is used, as the 2 index - is a hidden identifier of the first reference
        within '.edit-question .link:nth-child(3)' do
          fill_in 'Link name', with: 'Link to google'
          fill_in 'Url', with: google_url
        end

        within '.edit-question' do
          click_on 'Save'
        end

        # this link was added earlier and should be saved
        expect(page).to have_link link.name, href: link.url

        # new link
        expect(page).to have_link 'Link to google', href: google_url
      end

      scenario 'can update links from their question', js: true do
        within '.question' do
          click_on 'Edit'
        end

        within '.edit-question .link' do
          fill_in 'Link name', with: 'Link to google'
          fill_in 'Url', with: google_url
        end

        within '.edit-question' do
          click_on 'Save'
        end

        # this link was added earlier and should be updated
        expect(page).to have_no_link link.name, href: link.url

        # new link
        expect(page).to have_link 'Link to google', href: google_url
      end

      scenario 'can delete links from their question', js: true do
        within '.question' do
          click_on 'Edit'
        end

        within '.edit-question .link' do
          click_on 'Remove link'
        end

        within '.edit-question' do
          click_on 'Save'
        end

        # this link was added earlier and should be removed
        expect(page).to have_no_link link.name, href: link.url
      end
    end

    describe 'cannot edit their question' do
      scenario 'without filling in the title field', js: true do
        within '.question' do
          click_on 'Edit'
        end

        within '.edit-question' do
          fill_in 'Title', with: ''
          fill_in 'Body', with: 'New body'

          click_on 'Save'
        end

        expect(page).to have_content 'Title can\'t be blank'
      end

      scenario 'without filling in the body field', js: true do
        within '.question' do
          click_on 'Edit'
        end

        within '.edit-question' do
          fill_in 'Title', with: 'New title of the my question'
          fill_in 'Body', with: ''

          click_on 'Save'
        end

        expect(page).to have_content 'Body can\'t be blank'
      end

      describe 'with links' do
        given!(:their_question_with_links) { create(:question, user: user) }
        given!(:link) { create(:link, linkable: their_question_with_links) }
        given(:google_url) { 'http://google.com/' }

        background { visit question_path(their_question_with_links) }

        scenario 'without filling in the name of the link', js: true do
          within '.question' do
            click_on 'Edit'
          end

          within '.edit-question' do
            fill_in 'Link name', with: ''
            fill_in 'Url', with: google_url

            click_on 'Save'
          end

          expect(page).to have_content 'Links name can\'t be blank'
        end

        scenario 'without filling in the url of the link', js: true do
          within '.question' do
            click_on 'Edit'
          end

          within '.edit-question' do
            fill_in 'Link name', with: 'New link'
            fill_in 'Url', with: ''

            click_on 'Save'
          end

          expect(page).to have_content 'Links url can\'t be blank'
        end
      end
    end

    scenario 'does not see the link to edit someone else\'s question' do
      visit question_path(other_question)

      within '.question' do
        expect(page).to have_no_content 'Edit'
      end
    end
  end

  describe 'Guest' do
    scenario 'does not see the link to edit question' do
      visit question_path(other_question)

      within '.question' do
        expect(page).to have_no_content 'Edit'
      end
    end
  end
end
