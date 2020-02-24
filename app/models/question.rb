# frozen_string_literal: true

class Question < ApplicationRecord
  belongs_to :user
  has_many :answers, dependent: :destroy

  validates :title, :body, presence: true

  def author?(author)
    user == author
  end
end
