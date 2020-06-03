# frozen_string_literal: true

require 'rails_helper'

describe Question do
  it_behaves_like 'linkable'

  it { is_expected.to belong_to(:user) }

  it { is_expected.to have_many(:answers).order(best: :desc, created_at: :desc).dependent(:destroy) }
  it { is_expected.to have_one(:award).dependent(:destroy) }

  it { is_expected.to validate_presence_of :title }
  it { is_expected.to validate_presence_of :body }

  it { is_expected.to accept_nested_attributes_for :award }

  it 'have many attached files' do
    expect(described_class.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end
end
