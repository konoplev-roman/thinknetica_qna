# frozen_string_literal: true

require 'rails_helper'

feature 'User can view a list of answers to the question', %(
  In order to find a solution to problem
  I'd like to be able to view the question and list of answers for this
) do
  given(:question) { create(:question, title: 'Title of the question', body: 'Content of the question') }

  background do
    create(:answer, question: question, body: 'Content of the first answer')
    create(:answer, question: question, body: 'Content of the second answer')

    visit question_path(question)
  end

  scenario 'User can view a list of answers to the question' do
    within '.answers .card:nth-child(1)' do
      expect(page).to have_content 'Content of the second answer'
    end

    within '.answers .card:nth-child(2)' do
      expect(page).to have_content 'Content of the first answer'
    end

    expect(page).to have_css('.card', count: 2)
  end
end
