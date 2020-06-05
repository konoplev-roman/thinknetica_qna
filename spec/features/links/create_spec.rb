# frozen_string_literal: true

require 'rails_helper'

feature 'User can add links', %(
  In order to add information to a question or answer
  As an authenticated user
  I'd like to be able to add links to my question or answer
) do
  given(:question) { create(:question) }
  given(:google_url) { 'http://google.com/' }
  given(:gist_url) { 'https://gist.github.com/konoplev-roman/1152c4e0e09e1f8616c278a1a4a214a3' }

  describe 'with question' do
    background do
      visit new_question_path

      within '.edit-question' do
        fill_in 'Title', with: 'Title of the question'
        fill_in 'Body', with: 'Content of the question'

        click_on 'Add link'
      end
    end

    scenario 'can add links', js: true do
      within '.link' do
        fill_in 'Link name', with: 'Link to google'
        fill_in 'Url', with: google_url
      end

      click_on 'Ask'

      expect(page).to have_content 'Your question successfully created!'

      expect(page).to have_link 'Link to google', href: google_url
    end

    scenario 'can add links to gist', js: true do
      within '.link' do
        fill_in 'Link name', with: 'Link to gist'
        fill_in 'Url', with: gist_url
      end

      click_on 'Ask'

      expect(page).to have_content 'Your question successfully created!'

      expect(page).to have_link '1152c4e0e09e1f8616c278a1a4a214a3', href: gist_url
    end

    describe 'cannot add links' do
      scenario 'without filling in the name of the link', js: true do
        within '.link' do
          fill_in 'Link name', with: ''
          fill_in 'Url', with: google_url
        end

        click_on 'Ask'

        expect(page).to have_content 'Links name can\'t be blank'
      end

      scenario 'without filling in the url of the link', js: true do
        within '.link' do
          fill_in 'Link name', with: 'New link'
          fill_in 'Url', with: ''
        end

        click_on 'Ask'

        expect(page).to have_content 'Links url can\'t be blank'
      end

      scenario 'with invalid url of the link', js: true do
        within '.link' do
          fill_in 'Link name', with: 'New link'
          fill_in 'Url', with: 'invalid url'
        end

        click_on 'Ask'

        expect(page).to have_content 'Links url is not a valid URL'
      end
    end
  end

  describe 'with answer' do
    background do
      visit question_path(question)

      within '.new-answer' do
        fill_in 'Answer', with: 'Content of the answer'

        click_on 'Add link'
      end
    end

    scenario 'can add links', js: true do
      within '.new-answer' do
        within '.link' do
          fill_in 'Link name', with: 'Link to google'
          fill_in 'Url', with: google_url
        end

        click_on 'Post Your Answer'
      end

      expect(page).to have_content 'Your answer has been published successfully!'

      within '.answer' do
        expect(page).to have_link 'Link to google', href: google_url
      end
    end

    scenario 'can add links to gist', js: true do
      within '.new-answer' do
        within '.link' do
          fill_in 'Link name', with: 'Link to gits'
          fill_in 'Url', with: gist_url
        end

        click_on 'Post Your Answer'
      end

      expect(page).to have_content 'Your answer has been published successfully!'

      within '.answer' do
        expect(page).to have_link '1152c4e0e09e1f8616c278a1a4a214a3', href: gist_url
      end
    end

    describe 'cannot add links' do
      scenario 'without filling in the name of the link', js: true do
        within '.new-answer' do
          within '.link' do
            fill_in 'Link name', with: ''
            fill_in 'Url', with: google_url
          end
        end

        click_on 'Post Your Answer'

        expect(page).to have_content 'Links name can\'t be blank'
      end

      scenario 'without filling in the url of the link', js: true do
        within '.new-answer' do
          within '.link' do
            fill_in 'Link name', with: 'New link'
            fill_in 'Url', with: ''
          end
        end

        click_on 'Post Your Answer'

        expect(page).to have_content 'Links url can\'t be blank'
      end

      scenario 'with invalid url of the link', js: true do
        within '.new-answer' do
          within '.link' do
            fill_in 'Link name', with: 'New link'
            fill_in 'Url', with: 'invalid url'
          end
        end

        click_on 'Post Your Answer'

        expect(page).to have_content 'Links url is not a valid URL'
      end
    end
  end
end
