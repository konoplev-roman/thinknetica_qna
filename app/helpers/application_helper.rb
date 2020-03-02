# frozen_string_literal: true

module ApplicationHelper
  def flash_class(level)
    {
      notice: 'my-3 alert alert-info',
      success: 'my-3 alert alert-success',
      error: 'my-3 alert alert-danger',
      alert: 'my-3 alert alert-danger'
    }[level.to_sym]
  end
end
