# frozen_string_literal: true

class Answer < ApplicationRecord
  belongs_to :user
  belongs_to :question

  validates :question, :body, presence: true
  validates :best, uniqueness: { scope: :question_id }, if: :best?

  def best!
    transaction do
      question.answers.update_all(best: false) # rubocop:disable SkipsModelValidations

      update!(best: true)
    end
  end
end
