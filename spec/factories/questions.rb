# frozen_string_literal: true

FactoryBot.define do
  factory :question do
    user

    title { 'MyString' }
    body { 'MyText' }

    trait :invalid do
      title { nil }
    end

    trait :with_files do
      files do
        [
          fixture_file_upload(Rails.root.join('spec/rails_helper.rb')),
          fixture_file_upload(Rails.root.join('spec/spec_helper.rb'))
        ]
      end
    end

    trait :with_award do
      award
    end
  end
end
