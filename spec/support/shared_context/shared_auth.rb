# frozen_string_literal: true

shared_context 'with authorized user', auth: true do
  before { login(user) }
end

shared_context 'without authorized user', without_auth: true do
  before { sign_out(user) }
end
