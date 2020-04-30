# frozen_string_literal: true

class Answer < ApplicationRecord
  belongs_to :user
  belongs_to :question
  has_many :links, as: :linkable, dependent: :destroy, inverse_of: :linkable
  has_one :award, dependent: :destroy

  has_many_attached :files

  accepts_nested_attributes_for :links, reject_if: :all_blank, allow_destroy: true

  validates :user, :question, :body, presence: true
  validates :best, uniqueness: { scope: :question_id }, if: :best?

  def best!
    transaction do
      question.answers.update_all(best: false) # rubocop:disable SkipsModelValidations

      update!(best: true, award: question.award)
    end
  end
end
