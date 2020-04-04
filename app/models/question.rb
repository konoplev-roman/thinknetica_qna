# frozen_string_literal: true

class Question < ApplicationRecord
  belongs_to :user
  has_many :answers, -> { order(best: :desc, created_at: :desc) }, dependent: :destroy, inverse_of: :question
  has_many :links, as: :linkable, dependent: :destroy, inverse_of: :linkable

  has_many_attached :files

  accepts_nested_attributes_for :links, reject_if: :all_blank, allow_destroy: true

  validates :user, :title, :body, presence: true
end
