# frozen_string_literal: true

module VoteHelper
  # Up arrow
  def vote_up_text
    '&uarr;'.html_safe
  end

  # Down arrow
  def vote_down_text
    '&darr;'.html_safe
  end

  # Cross
  def vote_cancel_text
    '&times;'.html_safe
  end
end
