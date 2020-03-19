# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ApplicationHelper do
  describe '#flash_class' do
    it 'return styles for notices' do
      expect(helper.flash_class(:notice)).to eq('my-3 alert alert-info')
    end

    it 'return styles for success' do
      expect(helper.flash_class(:success)).to eq('my-3 alert alert-success')
    end

    it 'return styles for errors' do
      expect(helper.flash_class(:error)).to eq('my-3 alert alert-danger')
    end

    it 'return styles for alerts' do
      expect(helper.flash_class(:alert)).to eq('my-3 alert alert-danger')
    end
  end
end
