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

  describe 'DELETE #destroy' do
    context 'without authentication' do
      let!(:answer) { create(:answer, question: question) }

      it 'does not delete the answer' do
        expect { delete :destroy, params: { question_id: question, id: answer } }.not_to change(Answer, :count)
      end

      it 're-renders show login view' do
        delete :destroy, params: { question_id: question, id: answer }

        expect(response).to redirect_to new_user_session_path
      end
    end

    context 'with own answer' do
      before { login(user) }

      let!(:answer) { create(:answer, user: user, question: question) }

      it 'deletes the answer' do
        expect { delete :destroy, params: { question_id: question, id: answer } }.to change(Answer, :count).by(-1)
      end

      it 'redirects to show question view' do
        delete :destroy, params: { question_id: question, id: answer }

        expect(response).to redirect_to question
      end
    end

    context 'with someone else\'s answer' do
      before { login(user) }

      let!(:answer) { create(:answer, question: question) }

      it 'does not delete the answer' do
        expect { delete :destroy, params: { question_id: question, id: answer } }.not_to change(Answer, :count)
      end

      it 'returns a forbidden status code' do
        delete :destroy, params: { question_id: question, id: answer }

        expect(response).to have_http_status(:forbidden)
      end
    end
  end
end
