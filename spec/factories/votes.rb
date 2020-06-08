# frozen_string_literal: true

FactoryBot.define do
  factory :vote do
    user

    value { 1 }
  end
end
