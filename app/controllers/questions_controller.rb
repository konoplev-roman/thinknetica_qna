# frozen_string_literal: true

class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :check_author!, only: %i[update destroy]

  include Voted

  # This is a stub, used for indexing in before_action :authenticate_user!
  def index; end

  # This is a stub, used for indexing in before_action :authenticate_user!
  def show; end

  def create
    question.assign_attributes(question_params)

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
    question.destroy!

    redirect_to questions_path, notice: t('.success')
  end

  private

  def questions
    @questions ||= Question.all
  end

  def question
    @question ||= params[:id] ? Question.with_attached_files.find(params[:id]) : Question.new
  end

  def answer
    @answer ||= question.answers.new
  end

  helper_method :questions, :question, :answer

  def question_params
    params.require(:question).permit(
      :title, :body,
      files: [],
      links_attributes: %i[id name url _destroy],
      award_attributes: %i[id title image]
    )
  end

  def check_author!
    redirect_to question, status: :forbidden unless current_user.author?(question)
  end
end
