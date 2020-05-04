# frozen_string_literal: true

class AwardsController < ApplicationController
  before_action :authenticate_user!
  before_action :check_author!, only: :destroy

  expose :awards, -> { current_user.awards }
  expose :award, scope: -> { Award.with_attached_image }

  def destroy
    flash.notice = t('.success') if award.destroy
  end

  private

  def check_author!
    redirect_to root_path, status: :forbidden unless current_user&.author?(award.question)
  end
end
