# frozen_string_literal: true

class Question < ApplicationRecord
  belongs_to :user
  has_many :answers, -> { order(best: :desc, created_at: :desc) }, dependent: :destroy, inverse_of: :question

  validates :title, :body, presence: true
end
