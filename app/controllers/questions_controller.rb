# frozen_string_literal: true

class QuestionsController < ApplicationController
  before_action :authenticate_user!, only: %i[new create destroy]

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
    if question.update(question_params)
      redirect_to question
    else
      render :edit
    end
  end

  def destroy
    if current_user&.author?(question)
      question.destroy

      redirect_to questions_path, notice: t('.success')
    else
      render :show
    end
  end

  private

  def question_params
    params.require(:question).permit(:title, :body)
  end
end
