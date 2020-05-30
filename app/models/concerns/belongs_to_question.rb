# frozen_string_literal: true

module BelongsToQuestion
  extend ActiveSupport::Concern

  included do
    belongs_to :question
    validates :question, presence: true
  end
end
