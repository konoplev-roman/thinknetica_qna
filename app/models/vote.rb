# frozen_string_literal: true

class Vote < ApplicationRecord
  belongs_to :user
  belongs_to :voteable, polymorphic: true

  validates :user_id, uniqueness: { scope: %i[voteable_id voteable_type] }
  validates :value, presence: true, inclusion: { in: [-1, 1] }
  validate :validate_own_resource

  private

  def validate_own_resource
    # It's necessary because during validation the user or voteable can be nil.
    return if errors.present?

    errors.add(:voteable, :own_resource) if user.author?(voteable)
  end
end
