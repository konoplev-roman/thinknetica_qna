# frozen_string_literal: true

class Answer < ApplicationRecord
  belongs_to :user
  belongs_to :question

  validates :question, :body, presence: true
  validates :best, uniqueness: { scope: :question_id }, if: :best?

  def best!
    transaction do
      # Don't use update_all because it skips validations
      question.answers.find_by(best: true)&.update!(best: false)

      update!(best: true)
    end
  end
end
