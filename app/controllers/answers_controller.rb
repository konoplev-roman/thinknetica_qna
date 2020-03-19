# frozen_string_literal: true

class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :check_author!, only: %i[update destroy]
  before_action :check_question_author!, only: %i[best]

  def create
    answer.user = current_user

    flash.notice = t('.success') if answer.save
  end

  def update
    flash.notice = t('.success') if answer.update(answer_params)
  end

  def destroy
    flash.notice = t('.success') if answer.destroy
  end

  def best
    flash.notice = t('.success') if answer.best!
  end

  private

  def question
    @question ||= params[:question_id] ? Question.find(params[:question_id]) : answer.question
  end

  def answer
    # Answer is initialized immediately with the answer_params for the method :create, since there is no method :new
    @answer ||= params[:id] ? Answer.find(params[:id]) : question.answers.new(answer_params)
  end

  helper_method :answer, :question

  def answer_params
    params.require(:answer).permit(:body)
  end

  def check_author!
    redirect_to question, status: :forbidden unless current_user&.author?(answer)
  end

  def check_question_author!
    redirect_to question, status: :forbidden unless current_user&.author?(question)
  end
end
