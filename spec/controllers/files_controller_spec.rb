# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FilesController, type: :controller do
  let(:user) { create(:user) }

  describe 'DELETE #destroy' do
    subject(:destroy_request) { delete :destroy, params: { id: resource.files.first }, format: :js }

    context 'without authentication' do
      let!(:resource) { create(:question, :with_files) }

      it 'does not delete the file' do
        expect { destroy_request }.not_to change(resource.files, :count)
      end

      it 'returns a unauthorized status code' do
        destroy_request

        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'with own resource' do
      before { login(user) }

      let!(:resource) { create(:question, :with_files, user: user) }

      it 'deletes the file' do
        expect { destroy_request }.to change(resource.files, :count).by(-1)
      end

      it 'renders destroy file view' do
        destroy_request

        expect(response).to render_template :destroy
      end
    end

    context 'with someone else\'s resource' do
      before { login(user) }

      let!(:resource) { create(:question, :with_files) }

      it 'does not delete the file' do
        expect { destroy_request }.not_to change(resource.files, :count)
      end

      it 'returns a forbidden status code' do
        destroy_request

        expect(response).to have_http_status(:forbidden)
      end
    end
  end
end
