# frozen_string_literal: true

class AwardsController < ApplicationController
  before_action :authenticate_user!
  before_action :check_author!, only: :destroy

  def destroy
    award.destroy!

    flash.notice = t('.success')
  end

  private

  def awards
    @awards ||= current_user.awards
  end

  def award
    @award ||= Award.with_attached_image.find(params[:id])
  end

  helper_method :awards, :award

  def check_author!
    redirect_to root_path, status: :forbidden unless current_user.author?(award.question)
  end
end
