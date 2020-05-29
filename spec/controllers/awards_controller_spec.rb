# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AwardsController, type: :controller do
  let(:user) { create(:user) }

  describe 'DELETE #destroy' do
    subject(:destroy_request) { delete :destroy, params: { id: question.award }, format: :js }

    context 'without authentication' do
      let!(:question) { create(:question, :with_award) } # rubocop:disable RSpec/LetSetup

      it 'does not delete the award' do
        expect { destroy_request }.not_to change(Award, :count)
      end

      it 'returns a unauthorized status code' do
        destroy_request

        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'with own resource' do
      before { login(user) }

      let!(:question) { create(:question, :with_award, user: user) }

      it 'deletes the award' do
        destroy_request

        question.reload

        expect(question.award).to be_nil
      end

      it 'renders destroy award view' do
        destroy_request

        expect(response).to render_template :destroy
      end
    end

    context 'with someone else\'s resource' do
      before { login(user) }

      let!(:question) { create(:question, :with_award) }

      it 'does not delete the award' do
        destroy_request

        question.reload

        expect(question.award).not_to be_nil
      end

      it 'returns a forbidden status code' do
        destroy_request

        expect(response).to have_http_status(:forbidden)
      end
    end
  end
end
