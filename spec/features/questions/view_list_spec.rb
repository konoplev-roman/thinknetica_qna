# frozen_string_literal: true

require 'rails_helper'

feature 'User can view the list of questions', %(
  In order to help other users
  I'd like to be able to view the list of questions
) do
  scenario 'User can view a list of questions' do
    question1 = create(:question, title: 'Title of the first question', body: 'Content of the first question')
    question2 = create(:question, title: 'Title of the second question', body: 'Content of the second question')

    visit questions_path

    expect(page).to have_link 'Title of the first question', href: question_path(question1)
    expect(page).to have_content 'Content of the first question'

    expect(page).to have_link 'Title of the second question', href: question_path(question2)
    expect(page).to have_content 'Content of the second question'

    expect(page).to have_css('.card', count: 2)
  end
end
