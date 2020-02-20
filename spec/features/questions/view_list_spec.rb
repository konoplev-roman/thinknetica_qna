# frozen_string_literal: true

require 'rails_helper'

feature 'User can view the list of questions', %(
  In order to help other users
  I'd like to be able to view the list of questions
) do
  background do
    create(:question, title: 'Title of the first question', body: 'Content of the first question')
    create(:question, title: 'Title of the second question', body: 'Content of the second question')

    visit questions_path
  end

  scenario 'view the list of questions' do
    expect(page).to have_content 'Title of the first question'
    expect(page).to have_content 'Content of the first question'

    expect(page).to have_content 'Title of the second question'
    expect(page).to have_content 'Content of the second question'
  end
end
