# frozen_string_literal: true

shared_context 'with users' do
  let(:user) { create(:user) }
  let(:john) { create(:user, email: 'john@example.com') }
end
