# frozen_string_literal: true

require 'rails_helper'

feature 'User can vote for the question', %(
  In order to show sympathy for someone else's question
  As an authenticated user
  I'd like to be able to raise or lower the question rating
) do
  given(:question) { create(:question, user: john) }

  background do
    create_list(:vote, 10, voteable: question)

    visit question_path(question)
  end

  scenario 'can see rating', js: true do
    within '.question .votes .total' do
      expect(page).to have_content '10'
    end
  end

  scenario 'can see voting controls', js: true do
    within '.question .votes' do
      expect(page).to have_css '.vote_up'
      expect(page).to have_css '.vote_down'

      expect(page).to have_no_css '.vote_cancel'
    end
  end

  scenario 'can vote up', js: true do
    within '.question .votes' do
      find('.vote_up').click
    end

    within '.question .votes .total' do
      expect(page).to have_content '11'
    end

    expect(page).to have_content 'Your vote is accepted!'

    within '.question .votes' do
      expect(page).to have_no_css '.vote_up'
      expect(page).to have_no_css '.vote_down'

      expect(page).to have_css '.vote_cancel'
    end
  end

  scenario 'can vote down', js: true do
    within '.question .votes' do
      find('.vote_down').click
    end

    within '.question .votes .total' do
      expect(page).to have_content '9'
    end

    expect(page).to have_content 'Your vote is accepted!'

    within '.question .votes' do
      expect(page).to have_no_css '.vote_up'
      expect(page).to have_no_css '.vote_down'

      expect(page).to have_css '.vote_cancel'
    end
  end

  describe 'with already vote' do
    background do
      create(:vote, user: user, voteable: question)

      visit question_path(question)
    end

    scenario 'can see rating', js: true do
      within '.question .votes .total' do
        expect(page).to have_content '11'
      end
    end

    scenario 'can see voting controls', js: true do
      within '.question .votes' do
        expect(page).to have_no_css '.vote_up'
        expect(page).to have_no_css '.vote_down'

        expect(page).to have_css '.vote_cancel'
      end
    end

    scenario 'can cancel voice', js: true do
      within '.question .votes' do
        find('.vote_cancel').click
      end

      within '.question .votes .total' do
        expect(page).to have_content '10'
      end

      expect(page).to have_content 'Your vote was canceled!'

      within '.question .votes' do
        expect(page).to have_css '.vote_up'
        expect(page).to have_css '.vote_down'

        expect(page).to have_no_css '.vote_cancel'
      end
    end

    scenario 'can re-vote', js: true do
      within '.question .votes' do
        find('.vote_cancel').click

        find('.vote_down').click
      end

      within '.question .votes .total' do
        expect(page).to have_content '9'
      end

      expect(page).to have_content 'Your vote is accepted!'

      within '.question .votes' do
        expect(page).to have_no_css '.vote_up'
        expect(page).to have_no_css '.vote_down'

        expect(page).to have_css '.vote_cancel'
      end
    end
  end

  describe 'with own question' do
    given(:question) { create(:question, user: user) }

    scenario 'can see rating', js: true do
      within '.question .votes .total' do
        expect(page).to have_content '10'
      end
    end

    scenario 'does not see the links to voting controls', js: true do
      within '.question .votes' do
        expect(page).to have_no_css '.vote_up'
        expect(page).to have_no_css '.vote_down'
        expect(page).to have_no_css '.vote_cancel'
      end
    end
  end

  describe 'with creation of the question' do
    background { visit new_question_path }

    scenario 'does not see the links to voting controls and rating', js: true do
      expect(page).to have_no_css '.votes'
    end
  end

  describe 'Guest', :without_auth do
    background { visit question_path(question) }

    scenario 'can see rating' do
      within '.question .votes .total' do
        expect(page).to have_content '10'
      end
    end

    scenario 'does not see the links to voting controls' do
      within '.question .votes' do
        expect(page).to have_no_css '.vote_up'
        expect(page).to have_no_css '.vote_down'
        expect(page).to have_no_css '.vote_cancel'
      end
    end
  end
end
