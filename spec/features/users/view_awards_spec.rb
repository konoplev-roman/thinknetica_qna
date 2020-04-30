# frozen_string_literal: true

require 'rails_helper'

feature 'User can view their awards', %(
  In order to know my useful contribution
  As an authenticated user
  I'd like to be able to see my awards
) do
  given(:user1) { create(:user) }
  given(:user2) { create(:user) }

  given(:question1) { create(:question, user: user2, title: 'Title of the first question') }
  given(:question2) { create(:question, user: user2, title: 'Title of the second question') }
  given(:question3) { create(:question, user: user1, title: 'Other question') }

  given(:award1) { create(:award, question: question1, title: 'Title of the first award') }
  given(:award2) { create(:award, question: question2, title: 'Title of the second award') }
  given(:award3) { create(:award, question: question3, title: 'Other award') }

  background do
    create(:answer, user: user1, question: question1, best: true, award: award1)
    create(:answer, user: user1, question: question2, best: true, award: award2)
    create(:answer, user: user2, question: question3, best: true, award: award3)
  end

  describe 'Authenticated user' do
    background { login(user1) }

    scenario 'can use the link to view the awards' do
      visit root_path

      click_on 'Awards'

      expect(page).to have_current_path(awards_path)
    end

    scenario 'can view a list of their awards' do
      visit awards_path

      within '.media:nth-child(1)' do
        expect(page).to have_content 'Title of the first award'
        expect(page).to have_css("img[src*='star.png']")
        expect(page).to have_link 'Title of the first question', href: question_path(question1)
      end

      within '.media:nth-child(2)' do
        expect(page).to have_content 'Title of the second award'
        expect(page).to have_css("img[src*='star.png']")
        expect(page).to have_link 'Title of the second question', href: question_path(question2)
      end
    end

    scenario 'cannot view a list of someone else\'s awards' do
      visit awards_path

      expect(page).to have_no_content 'Other award'
      expect(page).to have_no_content 'Other question'
    end
  end

  describe 'Guest' do
    scenario 'does not see the link to view the awards' do
      visit root_path

      expect(page).to have_no_content 'Awards'
    end

    scenario 'cannot view the awards' do
      visit awards_path

      expect(page).to have_content 'You need to sign in or sign up before continuing.'

      expect(page).to have_no_content 'Other award'
      expect(page).to have_no_css("img[src*='star.png']")
      expect(page).to have_no_content 'Other question'
    end
  end
end
