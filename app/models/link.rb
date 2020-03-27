# frozen_string_literal: true

class Link < ApplicationRecord
  belongs_to :linkable, polymorphic: true

  validates :linkable, :name, :url, presence: true
end
