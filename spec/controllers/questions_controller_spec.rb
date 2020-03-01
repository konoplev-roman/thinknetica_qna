# frozen_string_literal: true

require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  describe 'POST #create' do
    let(:user) { create(:user) }

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
    let(:question) { create(:question) }

    context 'with valid attributes' do
      before { patch :update, params: { id: question, question: { title: 'new title', body: 'new body' } } }

      it 'changes question attribute title' do
        question.reload

        expect(question.title).to eq('new title')
      end

      it 'changes question attribute body' do
        question.reload

        expect(question.body).to eq('new body')
      end

      it 'redirects to updated question' do
        expect(response).to redirect_to question
      end
    end

    context 'with invalid attributes' do
      before { patch :update, params: { id: question, question: attributes_for(:question, :invalid) } }

      it 'does not change question attribute title' do
        question.reload

        expect(question.title).to eq('MyString')
      end

      it 'does not change question attribute body' do
        question.reload

        expect(question.body).to eq('MyText')
      end

      it 're-renders edit view' do
        expect(response).to render_template :edit
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:user) { create(:user) }

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

      it 're-renders show view' do
        delete :destroy, params: { id: question }

        expect(response).to render_template :show
      end
    end
  end
end
