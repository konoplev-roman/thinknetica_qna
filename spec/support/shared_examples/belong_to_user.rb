# frozen_string_literal: true

shared_examples_for 'belong to user' do |optional: false|
  if optional
    it { is_expected.to belong_to(:user).optional }
  else
    it { is_expected.to belong_to(:user) }
    it { is_expected.to validate_presence_of :user }
  end
end
