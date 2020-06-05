# frozen_string_literal: true

require 'rails_helper'

feature 'User can edit links', %(
  In order to change the question or answer information
  As an authenticated user
  I'd like to be able to edit links from my question or answer
) do
  given(:google_url) { 'http://google.com/' }
  given(:gist_url) { 'https://gist.github.com/konoplev-roman/1152c4e0e09e1f8616c278a1a4a214a3' }

  describe 'with question' do
    given(:their_question_with_links) { create(:question, user: user) }

    background do
      create(:link, linkable: their_question_with_links, name: 'Old link', url: 'http://example.com')

      visit question_path(their_question_with_links)

      within '.question' do
        click_on 'Edit'
      end
    end

    scenario 'can edit links', js: true do
      within '.edit-question .link' do
        fill_in 'Link name', with: 'Link to google'
        fill_in 'Url', with: google_url
      end

      within '.question' do
        click_on 'Save'
      end

      expect(page).to have_content 'Your question successfully updated!'

      # this link was added earlier and should be removed
      expect(page).to have_no_link 'Old link', href: 'http://example.com'

      # new link
      expect(page).to have_link 'Link to google', href: google_url
    end

    scenario 'can add more links', js: true do
      within '.edit-question' do
        click_on 'Add link'
      end

      # 3 index is used, as the 2 index - is a hidden identifier of the first reference
      within '.edit-question .link:nth-child(3)' do
        fill_in 'Link name', with: 'Link to google'
        fill_in 'Url', with: google_url
      end

      within '.question' do
        click_on 'Save'
      end

      expect(page).to have_content 'Your question successfully updated!'

      # this link was added earlier and should be saved
      expect(page).to have_link 'Old link', href: 'http://example.com'

      # new link
      expect(page).to have_link 'Link to google', href: google_url
    end

    describe 'cannot edit links' do
      scenario 'without filling in the name of the link', js: true do
        within '.edit-question .link' do
          fill_in 'Link name', with: ''
          fill_in 'Url', with: google_url
        end

        within '.question' do
          click_on 'Save'
        end

        expect(page).to have_content 'Links name can\'t be blank'
      end

      scenario 'without filling in the url of the link', js: true do
        within '.edit-question .link' do
          fill_in 'Link name', with: 'New link'
          fill_in 'Url', with: ''
        end

        within '.question' do
          click_on 'Save'
        end

        expect(page).to have_content 'Links url can\'t be blank'
      end

      scenario 'with invalid url of the link', js: true do
        within '.edit-question .link' do
          fill_in 'Link name', with: 'New link'
          fill_in 'Url', with: 'invalid url'
        end

        within '.question' do
          click_on 'Save'
        end

        expect(page).to have_content 'Links url is not a valid URL'
      end
    end
  end

  describe 'with answer' do
    given(:their_answer_with_links) { create(:answer, user: user) }

    background do
      create(:link, linkable: their_answer_with_links, name: 'Old link', url: 'http://example.com')

      visit question_path(their_answer_with_links.question)

      within "#answer-#{their_answer_with_links.id}" do
        click_on 'Edit'
      end
    end

    scenario 'can edit links', js: true do
      within "#answer-#{their_answer_with_links.id}" do
        within '.link' do
          fill_in 'Link name', with: 'Link to google'
          fill_in 'Url', with: google_url
        end

        click_on 'Save'

        # this link was added earlier and should be removed
        expect(page).to have_no_link 'Old link', href: 'http://example.com'

        # new link
        expect(page).to have_link 'Link to google', href: google_url
      end

      expect(page).to have_content 'Your answer successfully updated!'
    end

    scenario 'can add more links', js: true do
      within "#answer-#{their_answer_with_links.id}" do
        click_on 'Add link'

        # 3 index is used, as the 2 index - is a hidden identifier of the first reference
        within '.link:nth-child(3)' do
          fill_in 'Link name', with: 'Link to google'
          fill_in 'Url', with: google_url
        end

        click_on 'Save'

        # this link was added earlier and should be saved
        expect(page).to have_link 'Old link', href: 'http://example.com'

        # new link
        expect(page).to have_link 'Link to google', href: google_url
      end

      expect(page).to have_content 'Your answer successfully updated!'
    end

    describe 'cannot edit links' do
      scenario 'without filling in the name of the link', js: true do
        within "#answer-#{their_answer_with_links.id}" do
          within '.link' do
            fill_in 'Link name', with: ''
            fill_in 'Url', with: google_url
          end

          click_on 'Save'
        end

        expect(page).to have_content 'Links name can\'t be blank'
      end

      scenario 'without filling in the url of the link', js: true do
        within "#answer-#{their_answer_with_links.id}" do
          within '.link' do
            fill_in 'Link name', with: 'New link'
            fill_in 'Url', with: ''
          end

          click_on 'Save'
        end

        expect(page).to have_content 'Links url can\'t be blank'
      end

      scenario 'with invalid url of the link', js: true do
        within "#answer-#{their_answer_with_links.id}" do
          within '.link' do
            fill_in 'Link name', with: 'New link'
            fill_in 'Url', with: 'invalid url'
          end

          click_on 'Save'
        end

        expect(page).to have_content 'Links url is not a valid URL'
      end
    end
  end
end
