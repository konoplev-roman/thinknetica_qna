# frozen_string_literal: true

module Voteable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :voteable, dependent: :destroy, inverse_of: :voteable
  end
end
