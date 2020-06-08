# frozen_string_literal: true

require 'rails_helper'

describe VoteHelper do
  describe '#vote_up_text' do
    it 'return HTML entity of up arrow' do
      expect(helper.vote_up_text).to eq('&uarr;'.html_safe)
    end
  end

  describe '#vote_down_text' do
    it 'return HTML entity of down arrow' do
      expect(helper.vote_down_text).to eq('&darr;'.html_safe)
    end
  end

  describe '#vote_cancel_text' do
    it 'return HTML entity of cross' do
      expect(helper.vote_cancel_text).to eq('&times;'.html_safe)
    end
  end
end
