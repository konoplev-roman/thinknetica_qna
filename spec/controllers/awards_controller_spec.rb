# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AwardsController, type: :controller do
  let(:user) { create(:user) }

  describe 'DELETE #destroy' do
    context 'without authentication' do
      let!(:award) { create(:award) }

      it 'does not delete the award' do
        expect { delete :destroy, params: { id: award } }.not_to change(Award, :count)
      end

      it 'returns a unauthorized status code' do
        delete :destroy, params: { id: award }, format: :js

        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'with own resource' do
      before { login(user) }

      let!(:question) { create(:question, :with_award, user: user) }

      it 'deletes the award' do
        delete :destroy, params: { id: question.award }, format: :js

        question.reload

        expect(question.award).to be_nil
      end

      it 'renders destroy file view' do
        delete :destroy, params: { id: question.award }, format: :js

        expect(response).to render_template :destroy
      end
    end

    context 'with someone else\'s resource' do
      before { login(user) }

      let!(:question) { create(:question, :with_award) }

      it 'does not delete the file' do
        delete :destroy, params: { id: question.award }, format: :js

        question.reload

        expect(question.award).not_to be_nil
      end

      it 'returns a forbidden status code' do
        delete :destroy, params: { id: question.award }, format: :js

        expect(response).to have_http_status(:forbidden)
      end
    end
  end
end
