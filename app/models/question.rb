# frozen_string_literal: true

class Question < ApplicationRecord
  belongs_to :user
  has_many :answers, -> { order(best: :desc, created_at: :desc) }, dependent: :destroy, inverse_of: :question

  validates :title, :body, presence: true

  def best_answer!(answer)
    # Don't use update_all because it skips validations
    answers.find_by(best: true)&.update!(best: false)

    answer.update!(best: true)
  end
end
