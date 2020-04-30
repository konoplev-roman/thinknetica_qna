# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Award, type: :model do
  it { is_expected.to belong_to(:question) }
  it { is_expected.to belong_to(:answer).optional }

  it { is_expected.to validate_presence_of :question }
  it { is_expected.to validate_presence_of :title }
  it { is_expected.to validate_attached_of(:image) }
  it { is_expected.to validate_content_type_of(:image).allowing('image/png', 'image/jpg', 'image/jpeg') }

  it 'have one attached image' do
    expect(described_class.new.image).to be_an_instance_of(ActiveStorage::Attached::One)
  end
end
