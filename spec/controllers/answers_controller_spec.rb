# frozen_string_literal: true

require 'rails_helper'

describe AnswersController do
  let(:question) { create(:question, user: john) }

  it_behaves_like 'voted'

  describe 'POST #create' do
    let(:do_request) do
      post :create,
           params: { question_id: question, answer: attributes_for(:answer).merge(params) },
           format: :js
    end
    let(:params) { {} }

    context 'without authentication', :without_auth do
      it 'does not save the answer' do
        expect { do_request }.not_to change(Answer, :count)
      end

      it 'returns a unauthorized status code' do
        do_request

        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'with valid attributes' do
      it 'saves a new answer in the database' do
        expect { do_request }.to change(Answer, :count).by(1)
      end

      it 'saves a new answer nested to the current user and question', :aggregate_failures do
        do_request

        created_answer = Answer.order(id: :desc).first

        expect(created_answer.user).to eq(user)
        expect(created_answer.question).to eq(question)
      end

      it 'renders create answer view' do
        do_request

        expect(response).to render_template :create
      end
    end

    context 'with invalid attributes' do
      let(:params) { attributes_for(:answer, :invalid) }

      it 'does not save the answer' do
        expect { do_request }.not_to change(Answer, :count)
      end

      it 'renders create answer view' do
        do_request

        expect(response).to render_template :create
      end
    end
  end

  describe 'PATCH #update' do
    let!(:answer) { create(:answer, question: question, user: user) }

    let(:do_request) do
      patch :update,
            params: { id: answer, answer: { body: 'new body' }.merge(params) },
            format: :js
    end
    let(:params) { {} }

    context 'without authentication', :without_auth do
      before { do_request }

      it 'does not change answer attribute body' do
        answer.reload

        expect(answer.body).to eq('MyText')
      end

      it 'returns unauthorized error' do
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'with own answer with valid attributes' do
      before { do_request }

      it 'changes answer attribute body' do
        answer.reload

        expect(answer.body).to eq('new body')
      end

      it 'renders update answer view' do
        expect(response).to render_template :update
      end
    end

    context 'with own answer with invalid attributes' do
      let(:params) { attributes_for(:answer, :invalid) }

      before { do_request }

      it 'does not change answer attribute body' do
        answer.reload

        expect(answer.body).to eq('MyText')
      end

      it 'renders update answer view' do
        expect(response).to render_template :update
      end
    end

    context 'with someone else\'s answer' do
      let!(:answer) { create(:answer, question: question, user: john) }

      before { do_request }

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
    let!(:answer) { create(:answer, question: question) }

    let(:do_request) { patch :best, params: { id: answer }, format: :js }

    context 'without authentication', :without_auth do
      before { do_request }

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

      before { do_request }

      it 'saves answer as the best' do
        answer.reload

        expect(answer).to be_best
      end

      it 'renders best answer view' do
        expect(response).to render_template :best
      end
    end

    context 'with the answer to someone else\'s question' do
      before { do_request }

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
    let!(:answer) { create(:answer, user: user, question: question) }

    let(:do_request) { delete :destroy, params: { id: answer }, format: :js }

    context 'without authentication', :without_auth do
      it 'does not delete the answer' do
        expect { do_request }.not_to change(Answer, :count)
      end

      it 'returns a unauthorized status code' do
        do_request

        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'with own answer' do
      it 'deletes the answer' do
        expect { do_request }.to change(Answer, :count).by(-1)
      end

      it 'renders destroy answer view' do
        do_request

        expect(response).to render_template :destroy
      end
    end

    context 'with someone else\'s answer' do
      let!(:answer) { create(:answer, user: john, question: question) } # rubocop:disable RSpec/LetSetup

      it 'does not delete the answer' do
        expect { do_request }.not_to change(Answer, :count)
      end

      it 'returns a forbidden status code' do
        do_request

        expect(response).to have_http_status(:forbidden)
      end
    end
  end
end
