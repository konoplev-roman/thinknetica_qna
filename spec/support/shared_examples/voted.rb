# frozen_string_literal: true

shared_examples_for 'voted' do
  let(:model_klass) { described_class.to_s.sub('Controller', '').singularize }
  let(:resource_factory) { model_klass.underscore.to_sym }

  let!(:resource) { create(resource_factory, user: user) }

  describe 'POST #vote_up' do
    let(:do_request) { post :vote_up, params: { id: resource }, format: :json }

    context 'without authentication', :without_auth do
      it_behaves_like 'invalid vote', :unauthorized, 'You need to sign in or sign up before continuing.'
    end

    context 'with own resource' do
      it_behaves_like 'invalid vote', :unprocessable_entity, ['Voteable cannot be taken for its own resource']
    end

    context 'with someone else\'s resource with already voted' do
      let!(:resource) { create(resource_factory, user: john) }

      before { create(:vote, user: user, voteable: resource) }

      it_behaves_like 'invalid vote', :unprocessable_entity, ['User has already been taken']
    end

    context 'with someone else\'s resource' do
      let!(:resource) { create(resource_factory, user: john) }

      it 'saves a new vote in the database' do
        expect { do_request }.to change(Vote, :count).by(1)
      end

      it 'saves a new vote with value 1 and nested to the current user and resource', :aggregate_failures do
        do_request

        created_vote = Vote.order(id: :desc).first

        expect(created_vote.user).to eq(user)
        expect(created_vote.voteable).to eq(resource)

        expect(created_vote.value).to eq(1)
      end

      it 'returns a created status code' do
        do_request

        expect(response).to have_http_status(:created)
      end

      it 'renders json with object', :aggregate_failures do
        do_request

        expect(JSON.parse(response.body)['message']).to eq('Your vote is accepted!')
        expect(JSON.parse(response.body)['rating']).to eq(1)
      end
    end
  end

  describe 'POST #vote_down' do
    let(:do_request) { post :vote_down, params: { id: resource }, format: :json }

    context 'without authentication', :without_auth do
      it_behaves_like 'invalid vote', :unauthorized, 'You need to sign in or sign up before continuing.'
    end

    context 'with own resource' do
      it_behaves_like 'invalid vote', :unprocessable_entity, ['Voteable cannot be taken for its own resource']
    end

    context 'with someone else\'s resource with already voted' do
      let!(:resource) { create(resource_factory, user: john) }

      before { create(:vote, user: user, voteable: resource) }

      it_behaves_like 'invalid vote', :unprocessable_entity, ['User has already been taken']
    end

    context 'with someone else\'s resource' do
      let!(:resource) { create(resource_factory, user: john) }

      it 'saves a new vote in the database' do
        expect { do_request }.to change(Vote, :count).by(1)
      end

      it 'saves a new vote with value -1 and nested to the current user and resource', :aggregate_failures do
        do_request

        created_vote = Vote.order(id: :desc).first

        expect(created_vote.user).to eq(user)
        expect(created_vote.voteable).to eq(resource)

        expect(created_vote.value).to eq(-1)
      end

      it 'returns a created status code' do
        do_request

        expect(response).to have_http_status(:created)
      end

      it 'renders json with object', :aggregate_failures do
        do_request

        expect(JSON.parse(response.body)['message']).to eq('Your vote is accepted!')
        expect(JSON.parse(response.body)['rating']).to eq(-1)
      end
    end
  end

  describe 'DELETE #vote_cancel' do
    let!(:resource) { create(resource_factory, user: john) }

    let(:do_request) { delete :vote_cancel, params: { id: resource }, format: :json }

    context 'without authentication', :without_auth do
      it_behaves_like 'invalid vote', :unauthorized, 'You need to sign in or sign up before continuing.'
    end

    context 'without a vote' do
      it_behaves_like 'invalid vote', :not_found, 'Vote not found!'
    end

    context 'with a vote' do
      before { create(:vote, user: user, voteable: resource) }

      it 'deletes the vote' do
        expect { do_request }.to change(Vote, :count).by(-1)
      end

      it 'returns a OK status code' do
        do_request

        expect(response).to have_http_status(:ok)
      end

      it 'renders json with object', :aggregate_failures do
        do_request

        expect(JSON.parse(response.body)['message']).to eq('Your vote was canceled!')
        expect(JSON.parse(response.body)['rating']).to eq(0)
      end
    end
  end
end
