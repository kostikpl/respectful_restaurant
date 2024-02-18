RSpec.shared_examples 'with response body' do
  shared_examples 'returns correct body' do
    it do
      subject
      expect(parsed_response).to eq(expected_response)
    end
  end
end
