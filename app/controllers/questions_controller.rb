# frozen_string_literal: true

class QuestionsController < ApplicationController
  before_action :authenticate_user!, only: %i[new create update destroy]
  before_action :check_author!, only: %i[update destroy]

  expose :questions, -> { Question.all }
  expose :question
  expose :answer, -> { question.answers.new }

  # This is a stub, used for indexing in before_action :authenticate_user!
  # Redefined in Decent Exposure
  def new; end

  def create
    question.user = current_user

    if question.save
      redirect_to question, notice: t('.success')
    else
      render :new
    end
  end

  def update
    flash.notice = t('.success') if question.update(question_params)
  end

  def destroy
    if question.destroy
      redirect_to questions_path, notice: t('.success')
    else
      render :show
    end
  end

  private

  def question_params
    params.require(:question).permit(:title, :body)
  end

  def check_author!
    redirect_to question, status: :forbidden unless current_user&.author?(question)
  end
end
