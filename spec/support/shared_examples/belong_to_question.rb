# frozen_string_literal: true

shared_examples_for 'belong to question' do
  it { is_expected.to belong_to(:question) }
  it { is_expected.to validate_presence_of :question }
end
