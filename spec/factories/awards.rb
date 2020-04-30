# frozen_string_literal: true

FactoryBot.define do
  factory :award do
    question

    title { 'Cool!' }
    image { fixture_file_upload(Rails.root.join('spec/factories/images/star.png')) }

    answer { nil }
  end
end
