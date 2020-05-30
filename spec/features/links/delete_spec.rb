# frozen_string_literal: true

require 'rails_helper'

feature 'User can delete links', %(
  In order to delete the question or answer information
  As an authenticated user
  I'd like to be able to delete links from my question or answer
) do
  describe 'with question' do
    given(:their_question_with_links) { create(:question, user: user) }

    background do
      create(:link, linkable: their_question_with_links, name: 'Old link', url: 'http://example.com')

      visit question_path(their_question_with_links)

      within '.question' do
        click_on 'Edit'
      end
    end

    scenario 'can delete links', js: true do
      within '.link' do
        click_on 'Remove'
      end

      # this link was added earlier and should be removed
      expect(page).to have_no_link 'Old link', href: 'http://example.com'
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

    scenario 'can delete links', js: true do
      within "#answer-#{their_answer_with_links.id}" do
        within '.link' do
          click_on 'Remove'
        end

        # this link was added earlier and should be removed
        expect(page).to have_no_link 'Old link', href: 'http://example.com'
      end
    end
  end
end
