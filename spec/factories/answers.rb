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

    trait :with_files do
      files do
        [
          fixture_file_upload(Rails.root.join('spec/rails_helper.rb')),
          fixture_file_upload(Rails.root.join('spec/spec_helper.rb'))
        ]
      end
    end
  end
end
