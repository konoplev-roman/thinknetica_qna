# frozen_string_literal: true

require 'rails_helper'

describe AwardsController do
  describe 'DELETE #destroy' do
    subject(:destroy_request) { delete :destroy, params: { id: question.award }, format: :js }

    let!(:question) { create(:question, :with_award, user: user) }

    context 'without authentication', :without_auth do
      it 'does not delete the award' do
        expect { destroy_request }.not_to change(Award, :count)
      end

      it 'returns a unauthorized status code' do
        destroy_request

        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'with own resource' do
      before { destroy_request }

      it 'deletes the award' do
        question.reload

        expect(question.award).to be_nil
      end

      it 'renders destroy award view' do
        expect(response).to render_template :destroy
      end
    end

    context 'with someone else\'s resource' do
      let!(:question) { create(:question, :with_award, user: john) }

      before { destroy_request }

      it 'does not delete the award' do
        question.reload

        expect(question.award).not_to be_nil
      end

      it 'returns a forbidden status code' do
        expect(response).to have_http_status(:forbidden)
      end
    end
  end
end
