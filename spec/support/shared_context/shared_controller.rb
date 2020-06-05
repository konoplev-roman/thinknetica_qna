# frozen_string_literal: true

shared_context 'with controllers', type: :controller do
  include_context 'with users'
  include_context 'with authorized user'
end
