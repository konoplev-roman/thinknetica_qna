# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { is_expected.to belong_to(:user) }
  it { is_expected.to belong_to(:question) }

  it { is_expected.to validate_presence_of :question }
  it { is_expected.to validate_presence_of :body }

  describe 'author?' do
    let(:user) { create(:user) }

    it 'return true if the user is the author' do
      answer = create(:answer, user: user)

      expect(answer.author?(user)).to be(true)
    end

    it 'return false if the user is not the author' do
      answer = create(:answer)

      expect(answer.author?(user)).not_to be(true)
    end
  end
end
