# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question) }

  describe 'POST #create' do
    subject(:create_request) { post :create, params: params }

    let(:form_params) { {} }
    let(:params) do
      {
        format: :js,
        question_id: question,
        answer: attributes_for(:answer).merge(form_params)
      }
    end

    context 'without authentication' do
      it 'does not save the answer' do
        expect { create_request }.not_to change(Answer, :count)
      end

      it 'returns a unauthorized status code' do
        create_request

        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'with valid attributes' do
      before { login(user) }

      it 'saves a new answer in the database' do
        expect { create_request }.to change(Answer, :count).by(1)
      end

      it 'saves a new answer nested to the current user' do
        create_request

        created_answer = Answer.order(id: :desc).first

        expect(created_answer.user).to eq(user)
      end

      it 'saves a new answer nested to the selected question' do
        create_request

        created_answer = Answer.order(id: :desc).first

        expect(created_answer.question).to eq(question)
      end

      it 'renders create answer view' do
        create_request

        expect(response).to render_template :create
      end
    end

    context 'with invalid attributes' do
      let(:form_params) { attributes_for(:answer, :invalid) }

      before { login(user) }

      it 'does not save the answer' do
        expect { create_request }.not_to change(Answer, :count)
      end

      it 'renders create answer view' do
        create_request

        expect(response).to render_template :create
      end
    end
  end

  describe 'PATCH #update' do
    subject(:update_request) { patch :update, params: params }

    let(:form_params) { {} }
    let(:params) do
      {
        format: :js,
        id: answer,
        answer: { body: 'new body' }.merge(form_params)
      }
    end

    context 'without authentication' do
      let!(:answer) { create(:answer, question: question) }

      before { update_request }

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

        update_request
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

      let(:form_params) { attributes_for(:answer, :invalid) }

      before do
        login(user)

        update_request
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

        update_request
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
    subject(:best_request) { patch :best, params: { id: answer }, format: :js }

    context 'without authentication' do
      let!(:answer) { create(:answer) }

      before { best_request }

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

        best_request
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

        best_request
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
    subject(:destroy_request) { delete :destroy, params: { id: answer }, format: :js }

    context 'without authentication' do
      let!(:answer) { create(:answer, question: question) } # rubocop:disable RSpec/LetSetup

      it 'does not delete the answer' do
        expect { destroy_request }.not_to change(Answer, :count)
      end

      it 'returns a unauthorized status code' do
        destroy_request

        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'with own answer' do
      before { login(user) }

      let!(:answer) { create(:answer, user: user, question: question) } # rubocop:disable RSpec/LetSetup

      it 'deletes the answer' do
        expect { destroy_request }.to change(Answer, :count).by(-1)
      end

      it 'renders destroy answer view' do
        destroy_request

        expect(response).to render_template :destroy
      end
    end

    context 'with someone else\'s answer' do
      before { login(user) }

      let!(:answer) { create(:answer, question: question) } # rubocop:disable RSpec/LetSetup

      it 'does not delete the answer' do
        expect { destroy_request }.not_to change(Answer, :count)
      end

      it 'returns a forbidden status code' do
        destroy_request

        expect(response).to have_http_status(:forbidden)
      end
    end
  end
end
