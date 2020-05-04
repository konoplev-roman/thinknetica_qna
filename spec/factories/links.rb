# frozen_string_literal: true

FactoryBot.define do
  factory :link do
    name { 'My link' }
    url { 'http://example.com' }
  end
end
