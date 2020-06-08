# frozen_string_literal: true

shared_examples_for 'voteable' do
  it { is_expected.to have_many(:votes).dependent(:destroy) }

  describe '#rating' do
    let(:resource) { create(described_class.to_s.underscore.to_sym) }

    before do
      create_list(:vote, 10, voteable: resource, value: 1)
      create_list(:vote, 3, voteable: resource, value: -1)
    end

    it 'returns the amount of votes' do
      expect(resource.rating).to eq(7)
    end
  end
end
