RSpec.shared_context 'with response status' do
  shared_examples 'returns correct status' do
    it do
      subject
      expect(response.status).to eq(expected_status)
    end
  end
end
