# frozen_string_literal: true

class Answer < ApplicationRecord
  belongs_to :question

  validates :question, :body, presence: true
end
