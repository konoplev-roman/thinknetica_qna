# frozen_string_literal: true

shared_examples_for 'invalid vote' do |code, message|
  it 'does not change the count of instances of the model' do
    expect { do_request }.not_to change(Vote, :count)
  end

  it "returns a #{code} code" do
    do_request

    expect(response).to have_http_status(code)
  end

  it 'returns JSON with an error' do
    do_request

    expect(JSON.parse(response.body)['error']).to eq(message)
  end
end
