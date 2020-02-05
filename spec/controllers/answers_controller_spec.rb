# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'assigns a new answer nested to to the selected question' do
        post :create, params: { question_id: question, answer: attributes_for(:answer) }

        expect(assigns[:exposed_answer].question).to eq(question)
      end

      it 'saves a new answer in the database' do
        expected = expect { post :create, params: { question_id: question, answer: attributes_for(:answer) } }

        expected.to change(Answer, :count).by(1)
      end

      it 'redirects to index view' do
        post :create, params: { question_id: question, answer: attributes_for(:answer) }

        expect(response).to redirect_to question_answers_path(question)
      end
    end

    context 'with invalid attributes' do
      it 'does not save the answer' do
        expected = expect { post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid) } }

        expected.to_not change(Answer, :count)
      end

      it 're-renders new view' do
        post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid) }

        expect(response).to render_template :new
      end
    end
  end
end