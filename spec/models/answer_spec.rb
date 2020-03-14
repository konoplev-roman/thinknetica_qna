# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { is_expected.to belong_to(:user) }
  it { is_expected.to belong_to(:question) }

  it { is_expected.to validate_presence_of :question }
  it { is_expected.to validate_presence_of :body }

  context 'when the best' do
    subject { create(:answer, best: true) }

    it { is_expected.to validate_uniqueness_of(:best).scoped_to(:question_id) }
  end

  context 'when is not the best' do
    subject { create(:answer, best: false) }

    it { is_expected.not_to validate_uniqueness_of(:best).scoped_to(:question_id) }
  end

  describe '#best?' do
    let(:answer) { build(:answer) }
    let(:best_answer) { build(:answer, best: true) }

    it 'return true if the answer is the best' do
      expect(best_answer).to be_best
    end

    it 'return false if the answer is not the best' do
      expect(answer).not_to be_best
    end
  end
end
