# frozen_string_literal: true

require 'rails_helper'

describe LinkHelper do
  describe '#link_name' do
    let(:google_link) { build(:link, name: 'google', url: 'http://google.com/') }
    let(:gist_link) { build(:link, url: 'https://gist.github.com/konoplev-roman/1152c4e0e09e1f8616c278a1a4a214a3') }

    it 'return the gist hash if the link refers to the github gist' do
      expect(helper.link_name(gist_link)).to eq('1152c4e0e09e1f8616c278a1a4a214a3')
    end

    it 'return link name if the link does not refer to the github gist' do
      expect(helper.link_name(google_link)).to eq('google')
    end
  end
end
