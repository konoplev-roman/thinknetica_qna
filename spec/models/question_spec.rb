# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Question, type: :model do
  it { is_expected.to belong_to(:user) }
  it { is_expected.to have_many(:answers).dependent(:destroy) }

  it { is_expected.to validate_presence_of :title }
  it { is_expected.to validate_presence_of :body }

  describe 'author?' do
    let(:user) { create(:user) }

    it 'return true if the user is the author' do
      question = create(:question, user: user)

      expect(question.author?(user)).to be(true)
    end

    it 'return false if the user is not the author' do
      question = create(:question)

      expect(question.author?(user)).not_to be(true)
    end
  end
end
