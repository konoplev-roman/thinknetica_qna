# frozen_string_literal: true

require 'rails_helper'

describe Vote do
  include_context 'with users'

  it { is_expected.to belong_to(:user) }
  it { is_expected.to belong_to(:voteable) }

  it { is_expected.to validate_presence_of :value }
  it { is_expected.to validate_inclusion_of(:value).in_array([-1, 1]) }

  # It's necessary because validate_uniqueness_of works by matching a new record against an existing record.
  # If there is no existing record, it will create one using the record you provide.
  # While doing this, the following error was raised: null value in column "user_id" violates not-null constraint.
  # The best way to fix this is to provide the matcher with a record
  # where any required attributes are filled in with valid values beforehand.
  describe 'user/voteable relationship uniqueness' do
    subject { create(:vote, voteable: create(:question)) }

    it { is_expected.to validate_uniqueness_of(:user_id).scoped_to(%i[voteable_id voteable_type]) }
  end

  describe 'voting for own resource' do
    subject { build(:vote, user: user, voteable: create(:question, user: user)) }

    it { is_expected.not_to be_valid }
  end

  describe 'voting for other resource' do
    subject { build(:vote, user: user, voteable: create(:question, user: john)) }

    it { is_expected.to be_valid }
  end
end
