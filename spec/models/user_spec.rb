# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  it { is_expected.to validate_presence_of :email }
  it { is_expected.to validate_presence_of :password }
  it { is_expected.to have_many(:questions).dependent(:destroy) }
  it { is_expected.to have_many(:answers).dependent(:destroy) }

  describe '#author?' do
    let(:user) { create(:user) }
    let(:own_resource) { build(:question, user: user) }
    let(:other_resource) { build(:question) }

    it 'return true if the user is the author of the resource' do
      expect(user).to be_author(own_resource)
    end

    it 'return false if the user is not the author of the resource' do
      expect(user).not_to be_author(other_resource)
    end
  end

  describe '#awards' do
    let(:user1) { create(:user) }
    let(:user2) { create(:user) }

    let(:question1) { create(:question, user: user2) }
    let(:question2) { create(:question, user: user2) }
    let(:question3) { create(:question, user: user1) }

    let(:award1) { create(:award, question: question1) }
    let(:award2) { create(:award, question: question2) }
    let(:award3) { create(:award, question: question3) }

    before do
      create(:answer, user: user1, question: question1, best: true, award: award1)
      create(:answer, user: user1, question: question2, best: true, award: award2)
      create(:answer, user: user2, question: question3, best: true, award: award3)
    end

    it 'returns a collection of awards for best user answers' do
      expect(user1.awards).to contain_exactly(award1, award2)
    end
  end
end
