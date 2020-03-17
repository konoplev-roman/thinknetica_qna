# frozen_string_literal: true

require 'rails_helper'

RSpec.describe QuestionHelper do
  describe '#question_header' do
    it 'return the header to create the question' do
      expect(helper.question_header(build(:question))).to eq('Ask your question')
    end

    it 'return the header to edit the question' do
      expect(helper.question_header(create(:question))).to eq('Edit your question')
    end
  end

  describe '#question_form_options' do
    it 'return the option to disable remote for the create question form' do
      # By default form submits are remote and unobtrusive XHRs.
      # Disable remote submits with local: true
      expect(helper.question_form_options(build(:question))).to eq(local: true)
    end

    it 'return an empty options for the edit question form' do
      expect(helper.question_form_options(create(:question))).to be_empty
    end
  end
end
