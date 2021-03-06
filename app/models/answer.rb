# frozen_string_literal: true

class Answer < ApplicationRecord
  include Linkable
  include Voteable

  belongs_to :question
  belongs_to :user

  has_many_attached :files

  validates :body, presence: true
  validates :best, uniqueness: { scope: :question_id }, if: :best?

  def best!
    transaction do
      question.answers.update_all(best: false) # rubocop:disable SkipsModelValidations

      question.award&.update!(user: user)

      update!(best: true)
    end
  end
end
