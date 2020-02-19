# frozen_string_literal: true

require 'rails_helper'

feature 'User can create question', %(
  In order to get answer from a community
  I'd like to be able to ask the question
) do
  background do
    visit questions_path

    click_on 'Ask question'
  end

  scenario 'asks a question' do
    fill_in 'Title', with: 'Title of the question'
    fill_in 'Body', with: 'Content of the question'

    click_on 'Ask'

    expect(page).to have_content 'Your question successfully created!'

    expect(page).to have_content 'Title of the question'
    expect(page).to have_content 'Content of the question'
  end

  scenario 'asks a question with errors' do
    click_on 'Ask'

    expect(page).to have_content 'Title can\'t be blank'
  end
end
