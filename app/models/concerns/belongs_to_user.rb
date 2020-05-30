# frozen_string_literal: true

module BelongsToUser
  extend ActiveSupport::Concern

  included do
    belongs_to :user
    validates :user, presence: true
  end
end
