# frozen_string_literal: true

class AnswersController < ApplicationController
  before_action :authenticate_user!

  def create
    answer.user = current_user

    flash.notice = t('.success') if answer.save
  end

  def destroy
    if current_user&.author?(answer)
      answer.destroy

      redirect_to answer.question, notice: t('.success')
    else
      render 'questions/show'
    end
  end

  private

  def question
    @question ||= Question.find(params[:question_id])
  end

  def answer
    # Answer is initialized immediately with the answer_params for the method :create, since there is no method :new
    @answer ||= params[:id] ? Answer.find(params[:id]) : question.answers.new(answer_params)
  end

  helper_method :answer

  def answer_params
    params.require(:answer).permit(:body)
  end
end
