# frozen_string_literal: true

require 'rails_helper'

describe QuestionsController do
  describe 'POST #create' do
    subject(:create_request) { post :create, params: params }

    let(:form_params) { {} }
    let(:params) { { question: attributes_for(:question).merge(form_params) } }

    context 'without authentication', :without_auth do
      it 'does not save the question' do
        expect { create_request }.not_to change(Question, :count)
      end

      it 're-renders show login view' do
        create_request

        expect(response).to redirect_to new_user_session_path
      end
    end

    context 'with valid attributes' do
      it 'saves a new question in the database' do
        expect { create_request }.to change(Question, :count).by(1)
      end

      it 'saves a new question nested to the current user' do
        create_request

        created_question = Question.order(id: :desc).first

        expect(created_question.user).to eq(user)
      end

      it 'redirects to show view' do
        create_request

        created_question = Question.order(id: :desc).first

        expect(response).to redirect_to created_question
      end
    end

    context 'with invalid attributes' do
      let(:form_params) { attributes_for(:question, :invalid) }

      it 'does not save the question' do
        expect { create_request }.not_to change(Question, :count)
      end

      it 're-renders new view' do
        create_request

        expect(response).to render_template :new
      end
    end
  end

  describe 'PATCH #update' do
    subject(:update_request) { patch :update, params: params }

    let!(:question) { create(:question, user: user) }

    let(:form_params) { {} }
    let(:params) do
      {
        format: :js,
        id: question,
        question: { title: 'new title', body: 'new body' }.merge(form_params)
      }
    end

    context 'without authentication', :without_auth do
      before { update_request }

      it 'does not change question attributes', :aggregate_failures do
        question.reload

        expect(question.title).to eq('MyString')
        expect(question.body).to eq('MyText')
      end

      it 'returns a unauthorized status code' do
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'with own question with valid attributes' do
      before { update_request }

      it 'changes question attributes', :aggregate_failures do
        question.reload

        expect(question.title).to eq('new title')
        expect(question.body).to eq('new body')
      end

      it 'renders update question view' do
        expect(response).to render_template :update
      end
    end

    context 'with own question with invalid attributes' do
      let(:form_params) { attributes_for(:question, :invalid) }

      before { update_request }

      it 'does not change question attributes', :aggregate_failures do
        question.reload

        expect(question.title).to eq('MyString')
        expect(question.body).to eq('MyText')
      end

      it 'renders update question view' do
        expect(response).to render_template :update
      end
    end

    context 'with someone else\'s question' do
      let!(:question) { create(:question, user: john) }

      before { update_request }

      it 'does not change question attributes', :aggregate_failures do
        question.reload

        expect(question.title).to eq('MyString')
        expect(question.body).to eq('MyText')
      end

      it 'returns a forbidden status code' do
        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  describe 'DELETE #destroy' do
    subject(:destroy_request) { delete :destroy, params: { id: question } }

    let!(:question) { create(:question, user: user) }

    context 'without authentication', :without_auth do
      it 'does not delete the question' do
        expect { destroy_request }.not_to change(Question, :count)
      end

      it 're-renders show login view' do
        destroy_request

        expect(response).to redirect_to new_user_session_path
      end
    end

    context 'with own question' do
      it 'deletes the question' do
        expect { destroy_request }.to change(Question, :count).by(-1)
      end

      it 'redirects to index' do
        destroy_request

        expect(response).to redirect_to questions_path
      end
    end

    context 'with someone else\'s question' do
      let!(:question) { create(:question, user: john) } # rubocop:disable RSpec/LetSetup

      it 'does not delete the question' do
        expect { destroy_request }.not_to change(Question, :count)
      end

      it 'returns a forbidden status code' do
        destroy_request

        expect(response).to have_http_status(:forbidden)
      end
    end
  end
end
