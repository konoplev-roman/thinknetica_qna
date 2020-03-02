# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  it { is_expected.to validate_presence_of :email }
  it { is_expected.to validate_presence_of :password }
  it { is_expected.to have_many(:questions).dependent(:destroy) }
  it { is_expected.to have_many(:answers).dependent(:destroy) }

  describe '#author?' do
    let(:user) { create(:user) }

    it 'return true if the user is the author of the resource' do
      resource = create(:question, user: user)

      expect(user).to be_author(resource)
    end

    it 'return false if the user is not the author of the resource' do
      resource = create(:question)

      expect(user).not_to be_author(resource)
    end
  end
end
