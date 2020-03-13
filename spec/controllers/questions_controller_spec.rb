# frozen_string_literal: true

require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:user) { create(:user) }

  describe 'POST #create' do
    context 'without authentication' do
      it 'does not save the question' do
        expect {
          post :create, params: { question: attributes_for(:question) }
        }.not_to change(Question, :count)
      end

      it 're-renders show login view' do
        post :create, params: { question: attributes_for(:question) }

        expect(response).to redirect_to new_user_session_path
      end
    end

    context 'with valid attributes' do
      before { login(user) }

      it 'saves a new question in the database' do
        expect { post :create, params: { question: attributes_for(:question) } }.to change(Question, :count).by(1)
      end

      it 'saves a new question nested to the current user' do
        post :create, params: { question: attributes_for(:question) }

        created_question = Question.order(id: :desc).first

        expect(created_question.user).to eq(user)
      end

      it 'redirects to show view' do
        post :create, params: { question: attributes_for(:question) }

        created_question = Question.order(id: :desc).first

        expect(response).to redirect_to created_question
      end
    end

    context 'with invalid attributes' do
      before { login(user) }

      it 'does not save the question' do
        expect {
          post :create, params: { question: attributes_for(:question, :invalid) }
        }.not_to change(Question, :count)
      end

      it 're-renders new view' do
        post :create, params: { question: attributes_for(:question, :invalid) }

        expect(response).to render_template :new
      end
    end
  end

  describe 'PATCH #update' do
    context 'without authentication' do
      let!(:question) { create(:question) }

      before do
        patch :update, params: { id: question, question: { title: 'new title', body: 'new body' } }, format: :js
      end

      it 'does not change question attribute title' do
        question.reload

        expect(question.title).to eq('MyString')
      end

      it 'does not change question attribute body' do
        question.reload

        expect(question.body).to eq('MyText')
      end

      it 'returns a unauthorized status code' do
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'with own question with valid attributes' do
      let!(:question) { create(:question, user: user) }

      before do
        login(user)

        patch :update, params: { id: question, question: { title: 'new title', body: 'new body' } }, format: :js
      end

      it 'changes question attribute title' do
        question.reload

        expect(question.title).to eq('new title')
      end

      it 'changes question attribute body' do
        question.reload

        expect(question.body).to eq('new body')
      end

      it 'renders update question view' do
        expect(response).to render_template :update
      end
    end

    context 'with own question with invalid attributes' do
      let!(:question) { create(:question, user: user) }

      before do
        login(user)

        patch :update, params: { id: question, question: attributes_for(:question, :invalid) }, format: :js
      end

      it 'does not change question attribute title' do
        question.reload

        expect(question.title).to eq('MyString')
      end

      it 'does not change question attribute body' do
        question.reload

        expect(question.body).to eq('MyText')
      end

      it 'renders update question view' do
        expect(response).to render_template :update
      end
    end

    context 'with someone else\'s question' do
      let!(:question) { create(:question) }

      before do
        login(user)

        patch :update, params: { id: question, question: { title: 'new title', body: 'new body' } }, format: :js
      end

      it 'does not change question attribute title' do
        question.reload

        expect(question.title).to eq('MyString')
      end

      it 'does not change question attribute body' do
        question.reload

        expect(question.body).to eq('MyText')
      end

      it 'returns a forbidden status code' do
        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'without authentication' do
      let!(:question) { create(:question) }

      it 'does not delete the question' do
        expect { delete :destroy, params: { id: question } }.not_to change(Question, :count)
      end

      it 're-renders show login view' do
        delete :destroy, params: { id: question }

        expect(response).to redirect_to new_user_session_path
      end
    end

    context 'with own question' do
      before { login(user) }

      let!(:question) { create(:question, user: user) }

      it 'deletes the question' do
        expect { delete :destroy, params: { id: question } }.to change(Question, :count).by(-1)
      end

      it 'redirects to index' do
        delete :destroy, params: { id: question }

        expect(response).to redirect_to questions_path
      end
    end

    context 'with someone else\'s question' do
      before { login(user) }

      let!(:question) { create(:question) }

      it 'does not delete the question' do
        expect { delete :destroy, params: { id: question } }.not_to change(Question, :count)
      end

      it 'returns a forbidden status code' do
        delete :destroy, params: { id: question }

        expect(response).to have_http_status(:forbidden)
      end
    end
  end
end
