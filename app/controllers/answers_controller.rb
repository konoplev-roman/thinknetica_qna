# frozen_string_literal: true

class AnswersController < ApplicationController
  def index
    @answers = question.answers
  end

  def new; end

  def create
    @answer = question.answers.new(answer_params)

    if @answer.save
      redirect_to question_answers_path(question)
    else
      render :new
    end
  end

  private

  def question
    @question ||= Question.find(params[:question_id])
  end

  def answer
    @answer ||= question.answers.new
  end

  helper_method :question, :answer

  def answer_params
    params.require(:answer).permit(:body)
  end
end
