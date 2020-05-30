# frozen_string_literal: true

class Answer < ApplicationRecord
  include BelongsToUser

  belongs_to :question
  has_many :links, as: :linkable, dependent: :destroy, inverse_of: :linkable

  has_many_attached :files

  accepts_nested_attributes_for :links, reject_if: :all_blank, allow_destroy: true

  validates :question, :body, presence: true
  validates :best, uniqueness: { scope: :question_id }, if: :best?

  def best!
    transaction do
      question.answers.update_all(best: false) # rubocop:disable SkipsModelValidations

      question.award&.update!(user: user)

      update!(best: true)
    end
  end
end
