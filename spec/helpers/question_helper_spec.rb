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
end
