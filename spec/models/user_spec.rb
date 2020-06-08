# frozen_string_literal: true

require 'rails_helper'

describe User do
  include_context 'with users'

  it { is_expected.to validate_presence_of :email }
  it { is_expected.to validate_presence_of :password }
  it { is_expected.to have_many(:questions).dependent(:destroy) }
  it { is_expected.to have_many(:answers).dependent(:destroy) }
  it { is_expected.to have_many(:awards).dependent(:nullify) }
  it { is_expected.to have_many(:votes).dependent(:destroy) }

  describe '#author?' do
    let(:own_resource) { build(:question, user: user) }
    let(:other_resource) { build(:question) }

    it 'return true if the user is the author of the resource' do
      expect(user).to be_author(own_resource)
    end

    it 'return false if the user is not the author of the resource' do
      expect(user).not_to be_author(other_resource)
    end
  end

  describe '#voted?' do
    let(:resource) { create(:question) }
    let(:voted_resource) { create(:question) }

    before { create(:vote, user: user, voteable: voted_resource) }

    it 'return true if the user has voted for this resource' do
      expect(user).to be_voted(voted_resource)
    end

    it 'return false if the user has not voted for this resource' do
      expect(user).not_to be_voted(resource)
    end
  end
end
