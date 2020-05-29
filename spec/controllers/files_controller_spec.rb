# frozen_string_literal: true

require 'rails_helper'

describe FilesController do
  describe 'DELETE #destroy' do
    subject(:destroy_request) { delete :destroy, params: { id: resource.files.first }, format: :js }

    let!(:resource) { create(:question, :with_files, user: user) }

    context 'without authentication', :without_auth do
      it 'does not delete the file' do
        expect { destroy_request }.not_to change(resource.files, :count)
      end

      it 'returns a unauthorized status code' do
        destroy_request

        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'with own resource' do
      it 'deletes the file' do
        expect { destroy_request }.to change(resource.files, :count).by(-1)
      end

      it 'renders destroy file view' do
        destroy_request

        expect(response).to render_template :destroy
      end
    end

    context 'with someone else\'s resource' do
      let!(:resource) { create(:question, :with_files, user: john) }

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
