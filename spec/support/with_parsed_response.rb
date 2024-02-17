RSpec.shared_context 'with parsed response' do
  let(:parsed_response) { JSON.parse(response.body, symbolize_names: true) }
end
