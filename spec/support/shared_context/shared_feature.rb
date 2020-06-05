# frozen_string_literal: true

shared_context 'with features', type: :feature do
  include_context 'with users'
  include_context 'with authorized user'
end
