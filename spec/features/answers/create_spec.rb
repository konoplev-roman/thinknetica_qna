# frozen_string_literal: true

require 'rails_helper'

feature 'User can answer the question', %(
  In order to help the community
  I'd like to be able to answer the question
) do
  given(:question) { create(:question) }

  background { visit question_path(question) }

  scenario 'answer the question' do
    fill_in 'Answer', with: 'Content of the answer'

    click_on 'Post Your Answer'

    expect(page).to have_content 'Your answer has been published successfully!'

    expect(page).to have_content 'Content of the answer'

    expect(page).to have_current_path(question_path(question))
  end

  scenario 'answer the question with errors' do
    click_on 'Post Your Answer'

    expect(page).to have_content 'Answer can\'t be blank'
  end
end
