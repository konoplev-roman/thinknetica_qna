# frozen_string_literal: true

require 'rails_helper'

describe Answer do
  it { is_expected.to belong_to(:user) }
  it { is_expected.to belong_to(:question) }
  it { is_expected.to have_many(:links).dependent(:destroy) }

  it { is_expected.to validate_presence_of :user }
  it { is_expected.to validate_presence_of :question }
  it { is_expected.to validate_presence_of :body }

  it { is_expected.to accept_nested_attributes_for :links }

  it 'have many attached files' do
    expect(described_class.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end

  context 'when the best' do
    subject { create(:answer, best: true) }

    it { is_expected.to validate_uniqueness_of(:best).scoped_to(:question_id) }
  end

  context 'when is not the best' do
    subject { create(:answer, best: false) }

    it { is_expected.not_to validate_uniqueness_of(:best).scoped_to(:question_id) }
  end

  describe '#best!' do
    let(:question) { create(:question) }
    let!(:old_best_answer) { create(:answer, question: question, best: true) }
    let!(:new_best_answer) { create(:answer, question: question) }

    before { new_best_answer.best! }

    it 'make other answers to this question not the best' do
      old_best_answer.reload

      expect(old_best_answer).not_to be_best
    end

    it 'makes the answer best' do
      new_best_answer.reload

      expect(new_best_answer).to be_best
    end

    context 'when not appointed an award for the best answer' do
      it 'removes the award from authors of other answers' do
        old_best_answer.reload

        expect(old_best_answer.user.awards).to be_empty
      end

      it 'doesn\'t give an award to the author of the answer' do
        new_best_answer.reload

        expect(new_best_answer.user.awards).to be_empty
      end
    end

    context 'when appointed an award for the best answer' do
      let(:question) { create(:question, :with_award) }

      it 'removes the award from authors of other answers' do
        old_best_answer.reload

        expect(old_best_answer.user.awards).to be_empty
      end

      it 'gives an award to the author of the answer' do
        new_best_answer.reload

        expect(new_best_answer.user.awards).to contain_exactly(new_best_answer.question.award)
      end
    end
  end
end
