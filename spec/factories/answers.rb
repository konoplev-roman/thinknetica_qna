# frozen_string_literal: true

FactoryBot.define do
  factory :answer do
    question { nil }
    body { 'MyText' }
  end
end
