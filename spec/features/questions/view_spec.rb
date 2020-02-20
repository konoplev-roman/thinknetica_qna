# frozen_string_literal: true

require 'rails_helper'

feature 'User can view the question and list of answers for this', %(
  In order to find a solution to my problem
  I'd like to be able to view the question and list of answers for this
) do
  given(:question) { create(:question, title: 'Title of the question', body: 'Content of the question') }

  background do
    create(:answer, question: question, body: 'Content of the first answer')
    create(:answer, question: question, body: 'Content of the second answer')

    visit question_path(question)
  end

  scenario 'view the question' do
    expect(page).to have_content 'Title of the question'
    expect(page).to have_content 'Content of the question'
  end

  scenario 'view the list of answers' do
    expect(page).to have_content 'Content of the first answer'
    expect(page).to have_content 'Content of the second answer'
  end
end
