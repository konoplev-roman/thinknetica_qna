# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }

  describe 'POST #create' do
    let(:user) { create(:user) }

    before { login(user) }

    context 'with valid attributes' do
      it 'saves a new answer in the database' do
        expect {
          post :create, params: { question_id: question, answer: attributes_for(:answer) }
        }.to change(Answer, :count).by(1)
      end

      it 'saves a new answer nested to the crrent user' do
        post :create, params: { question_id: question, answer: attributes_for(:answer) }

        created_answer = Answer.order(id: :desc).first

        expect(created_answer.user).to eq(user)
      end

      it 'saves a new answer nested to the selected question' do
        post :create, params: { question_id: question, answer: attributes_for(:answer) }

        created_answer = Answer.order(id: :desc).first

        expect(created_answer.question).to eq(question)
      end

      it 'redirects to show question view' do
        post :create, params: { question_id: question, answer: attributes_for(:answer) }

        expect(response).to redirect_to question
      end
    end

    context 'with invalid attributes' do
      it 'does not save the answer' do
        expect {
          post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid) }
        }.not_to change(Answer, :count)
      end

      it 're-renders show question view' do
        post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid) }

        expect(response).to render_template 'questions/show'
      end
    end
  end
end
