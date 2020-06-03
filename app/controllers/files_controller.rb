# frozen_string_literal: true

class FilesController < ApplicationController
  before_action :authenticate_user!
  before_action :check_author!

  def destroy
    file.purge

    # This check is required because the purge method returns nil
    flash.notice = t('.success') if file.destroyed?
  end

  private

  def file
    @file ||= ActiveStorage::Attachment.find(params[:id])
  end

  helper_method :file

  def check_author!
    redirect_to root_path, status: :forbidden unless current_user.author?(file.record)
  end
end
