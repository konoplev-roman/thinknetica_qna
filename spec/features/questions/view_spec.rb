# frozen_string_literal: true

require 'rails_helper'

feature 'User can view the question', %(
  In order to find similar problems
  I'd like to be able to view the question
) do
  given(:question) { create(:question, title: 'Title of the question', body: 'Content of the question') }

  scenario 'User can view the question' do
    visit question_path(question)

    expect(page).to have_content 'Title of the question'
    expect(page).to have_content 'Content of the question'
  end
end
