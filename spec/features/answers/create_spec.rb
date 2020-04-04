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
    given(:google_url) { 'http://google.com/' }
    given(:gist_url) { 'https://gist.github.com/konoplev-roman/1152c4e0e09e1f8616c278a1a4a214a3' }

    background do
      login(user)

      visit question_path(question)
    end

    scenario 'can answer the question with valid attributes', js: true do
      within '.new-answer' do
        fill_in 'Answer', with: 'Content of the answer'

        click_on 'Post Your Answer'
      end

      expect(page).to have_current_path(question_path(question))

      expect(page).to have_content 'Your answer has been published successfully!'

      expect(page).to have_content 'Content of the answer'

      expect(page).to have_css('.card', count: 1)
    end

    scenario 'can attach a file by answer the question', js: true do
      within '.new-answer' do
        fill_in 'Answer', with: 'Content of the answer'

        attach_file 'Attach files', \
                    [Rails.root.join('spec/rails_helper.rb'), Rails.root.join('spec/spec_helper.rb')], \
                    visible: false

        click_on 'Post Your Answer'
      end

      within '.answer' do
        expect(page).to have_content 'rails_helper.rb'
        expect(page).to have_content 'spec_helper.rb'
      end
    end

    scenario 'can add links by by answer the question', js: true do
      within '.new-answer' do
        fill_in 'Answer', with: 'Content of the answer'

        click_on 'Add link'

        within '.link:nth-child(1)' do
          fill_in 'Link name', with: 'Link to google'
          fill_in 'Url', with: google_url
        end

        click_on 'Add link'

        within '.link:nth-child(2)' do
          fill_in 'Link name', with: 'Link to gist'
          fill_in 'Url', with: gist_url
        end

        click_on 'Post Your Answer'
      end

      within '.answer' do
        expect(page).to have_link 'Link to google', href: google_url
        expect(page).to have_link 'Link to gist', href: gist_url
      end
    end

    describe 'cannot answer the question' do
      scenario 'without filling in the answer field', js: true do
        within '.new-answer' do
          click_on 'Post Your Answer'
        end

        expect(page).to have_content 'Answer can\'t be blank'

        expect(page).to have_css('.card', count: 0)
      end

      scenario 'without filling in the name of the link', js: true do
        within '.new-answer' do
          fill_in 'Answer', with: 'Content of the answer'

          click_on 'Add link'

          fill_in 'Url', with: google_url

          click_on 'Add link'

          click_on 'Post Your Answer'
        end

        expect(page).to have_content 'Links name can\'t be blank'
      end

      scenario 'without filling in the url of the link', js: true do
        within '.new-answer' do
          fill_in 'Answer', with: 'Content of the answer'

          click_on 'Add link'

          fill_in 'Link name', with: 'Link to google'

          click_on 'Add link'

          click_on 'Post Your Answer'
        end

        expect(page).to have_content 'Links url can\'t be blank'
      end

      scenario 'with invalid url of the link', js: true do
        within '.new-answer' do
          fill_in 'Answer', with: 'Content of the answer'

          click_on 'Add link'

          fill_in 'Link name', with: 'Link to google'
          fill_in 'Url', with: 'invalid url'

          click_on 'Add link'

          click_on 'Post Your Answer'
        end

        expect(page).to have_content 'Links url is not a valid URL'
      end
    end
  end

  describe 'Guest' do
    scenario 'does not see the link to answer the question' do
      visit question_path(question)

      within '.new-answer' do
        expect(page).to have_no_content 'Post Your Answer'
      end
    end
  end
end
