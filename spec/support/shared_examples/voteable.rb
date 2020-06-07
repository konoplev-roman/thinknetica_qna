# frozen_string_literal: true

shared_examples_for 'voteable' do
  it { is_expected.to have_many(:votes).dependent(:destroy) }
end
