# frozen_string_literal: true

class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :check_author!, only: %i[update destroy]

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

  def check_author!
    redirect_to answer.question, status: :forbidden unless current_user&.author?(answer)
  end
end
