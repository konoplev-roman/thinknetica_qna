# frozen_string_literal: true

class Question < ApplicationRecord
  belongs_to :user
  has_many :answers, -> { order(best: :desc) }, dependent: :destroy, inverse_of: :question

  validates :title, :body, presence: true

  def best_answer
    answers.find_by(best: true)
  end

  def best_answer!(answer)
    best_answer&.update(best: false)

    answer.update!(best: true)
  end
end
