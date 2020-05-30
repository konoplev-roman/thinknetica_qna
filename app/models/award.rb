# frozen_string_literal: true

class Award < ApplicationRecord
  include BelongsToQuestion

  belongs_to :user, optional: true

  has_one_attached :image

  validates :title, presence: true
  validates :image, attached: true, content_type: %w[image/png image/jpg image/jpeg]
end
