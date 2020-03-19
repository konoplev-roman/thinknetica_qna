# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question) }

  describe 'POST #create' do
    context 'without authentication' do
      it 'does not save the answer' do
        expect {
          post :create, params: { question_id: question, answer: attributes_for(:answer) }, format: :js
        }.not_to change(Answer, :count)
      end

      it 'returns a unauthorized status code' do
        post :create, params: { question_id: question, answer: attributes_for(:answer) }, format: :js

        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'with valid attributes' do
      before { login(user) }

      it 'saves a new answer in the database' do
        expect {
          post :create, params: { question_id: question, answer: attributes_for(:answer) }, format: :js
        }.to change(Answer, :count).by(1)
      end

      it 'saves a new answer nested to the current user' do
        post :create, params: { question_id: question, answer: attributes_for(:answer) }, format: :js

        created_answer = Answer.order(id: :desc).first

        expect(created_answer.user).to eq(user)
      end

      it 'saves a new answer nested to the selected question' do
        post :create, params: { question_id: question, answer: attributes_for(:answer) }, format: :js

        created_answer = Answer.order(id: :desc).first

        expect(created_answer.question).to eq(question)
      end

      it 'renders create answer view' do
        post :create, params: { question_id: question, answer: attributes_for(:answer) }, format: :js

        expect(response).to render_template :create
      end
    end

    context 'with invalid attributes' do
      before { login(user) }

      it 'does not save the answer' do
        expect {
          post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid) }, format: :js
        }.not_to change(Answer, :count)
      end

      it 'renders create answer view' do
        post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid) }, format: :js

        expect(response).to render_template :create
      end
    end
  end

  describe 'PATCH #update' do
    context 'without authentication' do
      let!(:answer) { create(:answer, question: question) }

      before { patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js }

      it 'does not change answer attribute body' do
        answer.reload

        expect(answer.body).to eq('MyText')
      end

      it 'returns unauthorized error' do
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'with own answer with valid attributes' do
      let!(:answer) { create(:answer, question: question, user: user) }

      before do
        login(user)

        patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js
      end

      it 'changes answer attribute body' do
        answer.reload

        expect(answer.body).to eq('new body')
      end

      it 'renders update answer view' do
        expect(response).to render_template :update
      end
    end

    context 'with own answer with invalid attributes' do
      let!(:answer) { create(:answer, question: question, user: user) }

      before do
        login(user)

        patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js
      end

      it 'does not change answer attribute body' do
        answer.reload

        expect(answer.body).to eq('MyText')
      end

      it 'renders update answer view' do
        expect(response).to render_template :update
      end
    end

    context 'with someone else\'s answer' do
      let!(:answer) { create(:answer, question: question) }

      before do
        login(user)

        patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js
      end

      it 'does not change answer attribute body' do
        answer.reload

        expect(answer.body).to eq('MyText')
      end

      it 'returns forbidden error' do
        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  describe 'PATCH #best' do
    context 'without authentication' do
      let!(:answer) { create(:answer) }

      before { patch :best, params: { id: answer }, format: :js }

      it 'does not save answer as the best' do
        answer.reload

        expect(answer).not_to be_best
      end

      it 'returns unauthorized error' do
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'with the answer to own question' do
      let(:question) { create(:question, user: user) }
      let!(:answer) { create(:answer, question: question) }

      before do
        login(user)

        patch :best, params: { id: answer }, format: :js
      end

      it 'saves answer as the best' do
        answer.reload

        expect(answer).to be_best
      end

      it 'renders best answer view' do
        expect(response).to render_template :best
      end
    end

    context 'with the answer to someone else\'s question' do
      let(:question) { create(:question) }
      let!(:answer) { create(:answer, question: question) }

      before do
        login(user)

        patch :best, params: { id: answer }, format: :js
      end

      it 'does not save answer as the best' do
        answer.reload

        expect(answer).not_to be_best
      end

      it 'returns forbidden error' do
        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'without authentication' do
      let!(:answer) { create(:answer, question: question) }

      it 'does not delete the answer' do
        expect {
          delete :destroy, params: { id: answer }, format: :js
        }.not_to change(Answer, :count)
      end

      it 'returns a unauthorized status code' do
        delete :destroy, params: { id: answer }, format: :js

        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'with own answer' do
      before { login(user) }

      let!(:answer) { create(:answer, user: user, question: question) }

      it 'deletes the answer' do
        expect {
          delete :destroy, params: { id: answer }, format: :js
        }.to change(Answer, :count).by(-1)
      end

      it 'renders destroy answer view' do
        delete :destroy, params: { id: answer }, format: :js

        expect(response).to render_template :destroy
      end
    end

    context 'with someone else\'s answer' do
      before { login(user) }

      let!(:answer) { create(:answer, question: question) }

      it 'does not delete the answer' do
        expect {
          delete :destroy, params: { id: answer }, format: :js
        }.not_to change(Answer, :count)
      end

      it 'returns a forbidden status code' do
        delete :destroy, params: { id: answer }, format: :js

        expect(response).to have_http_status(:forbidden)
      end
    end
  end
end
