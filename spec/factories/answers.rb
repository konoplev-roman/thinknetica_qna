# frozen_string_literal: true

FactoryBot.define do
  factory :answer do
    user
    question

    body { 'MyText' }

    best { false }

    trait :invalid do
      body { nil }
    end
  end
end
