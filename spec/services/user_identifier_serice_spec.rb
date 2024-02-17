require 'rails_helper'

RSpec.describe UserIdentifierService do
  subject do
    described_class.new(params).call
  end
  let(:first_name) { Faker::Name.first_name }
  let(:last_name) { Faker::Name.last_name }
  let(:user_id) { SecureRandom.uuid }
  let(:params) do
    {
      first_name: first_name,
      last_name: last_name
    }
  end
  let(:file_content) do
    "{ \"#{user_id}\": { \"firstName\": \"#{first_name}\", \"lastName\": \"#{last_name}\"} } "
  end

  shared_examples 'returns correct status' do
    it do
      expect(subject.status).to eq(expected_status)
    end
  end

  shared_examples 'returns unsuccessful result' do
    it do
      expect(subject.success?).to be_falsy
    end
  end

  shared_examples 'returns error message' do
    it do
      expect(subject.error_msg).to be_present
    end
  end

  context 'when user identified successfully' do
    before do
      allow(File).to receive(:read).and_return(file_content)
    end

    let(:expected_output) { { id: user_id } }
    let(:expected_status) { 200 }

    it 'returns correct user id' do
      expect(subject.output).to eq(expected_output)
    end

    it 'returns successful result' do
      expect(subject.success?).to be_truthy
    end

    it_behaves_like 'returns correct status'
  end

  context 'when user is not identified' do
    context 'when file with users is not exists' do
      before do
        allow(File).to receive(:read).and_raise(Errno::ENOENT)
      end
      let(:expected_status) { 500 }

      it_behaves_like 'returns correct status'
      it_behaves_like 'returns unsuccessful result'
      it_behaves_like 'returns error message'
    end

    context 'when file can not be read' do
      before do
        allow(JSON).to receive(:parse).and_raise(JSON::ParserError)
      end
      let(:expected_status) { 500 }
      it_behaves_like 'returns unsuccessful result'
      it_behaves_like 'returns error message'
      it_behaves_like 'returns correct status'
    end

    context 'when user is absent in file' do
      let(:expected_status) { 404 }
      let(:file_content) do
        "{ \"#{SecureRandom.uuid}\": { \"firstName\": \"#{Faker::Name.firstName}\",\
           \"lastName\": \"#{Faker.last}\"} }"
      end

      it_behaves_like 'returns unsuccessful result'
      it_behaves_like 'returns error message'
      it_behaves_like 'returns correct status'
    end
  end

  # we need to know that actual file is not broken
  describe '#load_users' do
    it 'read and parse file with users' do
      expect {
        described_class.new(params).send(:load_users)
      }.not_to raise_error
    end
  end
end
