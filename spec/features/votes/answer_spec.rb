# frozen_string_literal: true

require 'rails_helper'

feature 'User can vote for the answer', %(
  In order to show sympathy for someone else's answer
  As an authenticated user
  I'd like to be able to raise or lower the answer rating
) do
  given(:answer) { create(:answer, user: john) }

  background do
    create_list(:vote, 10, voteable: answer)

    visit question_path(answer.question)
  end

  scenario 'can see rating', js: true do
    within '.answer .votes .total' do
      expect(page).to have_content '10'
    end
  end

  scenario 'can see voting controls', js: true do
    within '.answer .votes' do
      expect(page).to have_css '.vote_up'
      expect(page).to have_css '.vote_down'

      expect(page).to have_no_css '.vote_cancel'
    end
  end

  scenario 'can vote up', js: true do
    within '.answer .votes' do
      find('.vote_up').click
    end

    within '.answer .votes .total' do
      expect(page).to have_content '11'
    end

    expect(page).to have_content 'Your vote is accepted!'

    within '.answer .votes' do
      expect(page).to have_no_css '.vote_up'
      expect(page).to have_no_css '.vote_down'

      expect(page).to have_css '.vote_cancel'
    end
  end

  scenario 'can vote down', js: true do
    within '.answer .votes' do
      find('.vote_down').click
    end

    within '.answer .votes .total' do
      expect(page).to have_content '9'
    end

    expect(page).to have_content 'Your vote is accepted!'

    within '.answer .votes' do
      expect(page).to have_no_css '.vote_up'
      expect(page).to have_no_css '.vote_down'

      expect(page).to have_css '.vote_cancel'
    end
  end

  describe 'with already vote' do
    background do
      create(:vote, user: user, voteable: answer)

      visit question_path(answer.question)
    end

    scenario 'can see rating', js: true do
      within '.answer .votes .total' do
        expect(page).to have_content '11'
      end
    end

    scenario 'can see voting controls', js: true do
      within '.answer .votes' do
        expect(page).to have_no_css '.vote_up'
        expect(page).to have_no_css '.vote_down'

        expect(page).to have_css '.vote_cancel'
      end
    end

    scenario 'can cancel voice', js: true do
      within '.answer .votes' do
        find('.vote_cancel').click
      end

      within '.answer .votes .total' do
        expect(page).to have_content '10'
      end

      expect(page).to have_content 'Your vote was canceled!'

      within '.answer .votes' do
        expect(page).to have_css '.vote_up'
        expect(page).to have_css '.vote_down'

        expect(page).to have_no_css '.vote_cancel'
      end
    end

    scenario 'can re-vote', js: true do
      within '.answer .votes' do
        find('.vote_cancel').click

        find('.vote_down').click
      end

      within '.answer .votes .total' do
        expect(page).to have_content '9'
      end

      expect(page).to have_content 'Your vote is accepted!'

      within '.answer .votes' do
        expect(page).to have_no_css '.vote_up'
        expect(page).to have_no_css '.vote_down'

        expect(page).to have_css '.vote_cancel'
      end
    end
  end

  describe 'with own answer' do
    given(:answer) { create(:answer, user: user) }

    scenario 'can see rating', js: true do
      within '.answer .votes .total' do
        expect(page).to have_content '10'
      end
    end

    scenario 'does not see the links to voting controls', js: true do
      within '.answer .votes' do
        expect(page).to have_no_css '.vote_up'
        expect(page).to have_no_css '.vote_down'
        expect(page).to have_no_css '.vote_cancel'
      end
    end
  end

  describe 'with creation of the answer' do
    background { visit question_path(answer.question) }

    scenario 'does not see the links to voting controls and rating', js: true do
      within '.new-answer' do
        expect(page).to have_no_css '.votes'
      end
    end
  end

  describe 'Guest', :without_auth do
    background { visit question_path(answer.question) }

    scenario 'can see rating' do
      within '.answer .votes .total' do
        expect(page).to have_content '10'
      end
    end

    scenario 'does not see the links to voting controls' do
      within '.answer .votes' do
        expect(page).to have_no_css '.vote_up'
        expect(page).to have_no_css '.vote_down'
        expect(page).to have_no_css '.vote_cancel'
      end
    end
  end
end
