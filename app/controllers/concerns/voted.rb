# frozen_string_literal: true

module Voted
  extend ActiveSupport::Concern

  def vote_up
    vote = Vote.new(user: current_user, voteable: voteable, value: 1)

    if vote.save
      render json: { message: t('vote.success'), rating: voteable.rating }, status: :created
    else
      render json: { error: vote.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def vote_down
    vote = Vote.new(user: current_user, voteable: voteable, value: -1)

    if vote.save
      render json: { message: t('vote.success'), rating: voteable.rating }, status: :created
    else
      render json: { error: vote.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def vote_cancel
    vote = Vote.find_by(user: current_user, voteable: voteable)

    if vote
      vote.destroy!

      render json: { message: t('vote.canceled'), rating: voteable.rating }, status: :ok
    else
      render json: { error: t('vote.not_found') }, status: :not_found
    end
  end

  private

  def model_klass
    controller_name.classify.constantize
  end

  def voteable
    @voteable ||= model_klass.find(params[:id])
  end
end
