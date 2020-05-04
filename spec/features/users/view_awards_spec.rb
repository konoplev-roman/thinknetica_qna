# frozen_string_literal: true

require 'rails_helper'

feature 'User can view their awards', %(
  In order to know my useful contribution
  As an authenticated user
  I'd like to be able to see my awards
) do
  given(:user) { create(:user) }

  given(:question1) { create(:question, title: 'Title of the first question') }
  given(:question2) { create(:question, title: 'Title of the second question') }
  given(:question3) { create(:question, title: 'Other question') }

  background do
    create(:award, question: question1, title: 'Title of the first award')
    create(:award, question: question2, title: 'Title of the second award')
    create(:award, question: question3, title: 'Other award')

    create(:answer, user: user, question: question1).best!
    create(:answer, user: user, question: question2).best!
    create(:answer, question: question3).best!
  end

  describe 'Authenticated user' do
    background { login(user) }

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
