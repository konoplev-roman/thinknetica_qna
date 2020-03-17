# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Question, type: :model do
  it { is_expected.to belong_to(:user) }
  it { is_expected.to have_many(:answers).order(best: :desc, created_at: :desc).dependent(:destroy) }

  it { is_expected.to validate_presence_of :title }
  it { is_expected.to validate_presence_of :body }

  describe '#best_answer!' do
    let(:question) { create(:question) }
    let!(:old_best_answer) { create(:answer, question: question, best: true) }
    let!(:new_best_answer) { build(:answer, question: question) }

    before { question.best_answer!(new_best_answer) }

    it 'make other answers to this question not the best' do
      old_best_answer.reload

      expect(old_best_answer).not_to be_best
    end

    it 'makes the answer best' do
      new_best_answer.reload

      expect(new_best_answer).to be_best
    end
  end
end
