# frozen_string_literal: true

class Answer < ApplicationRecord
  belongs_to :user
  belongs_to :question

  validates :question, :body, presence: true
  validates :best, uniqueness: { scope: :question_id }, if: :best?
end
