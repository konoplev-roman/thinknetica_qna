# frozen_string_literal: true

class Question < ApplicationRecord
  include BelongsToUser

  has_many :answers, -> { order(best: :desc, created_at: :desc) }, dependent: :destroy, inverse_of: :question
  has_many :links, as: :linkable, dependent: :destroy, inverse_of: :linkable
  has_one :award, dependent: :destroy

  has_many_attached :files

  accepts_nested_attributes_for :links, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :award, reject_if: :all_blank, allow_destroy: true

  validates :title, :body, presence: true
end
