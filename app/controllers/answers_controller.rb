# frozen_string_literal: true

class AnswersController < ApplicationController
  before_action :authenticate_user!, only: %i[create]

  expose :question
  expose :answers, from: :question
  expose :answer, parent: :question

  def create
    answer.user = current_user

    if answer.save
      redirect_to question, notice: t('.success')
    else
      render 'questions/show'
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end
end
