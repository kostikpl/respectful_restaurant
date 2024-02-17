require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  include_context 'with parsed response'

  describe '#show' do
    shared_examples 'call UserIdentifierService once' do
      it do
        expect(UserIdentifierService)
          .to receive(:new)
          .with(params: wrapped_params)
          .once

        expect(user_identifier_instance_double).to receive(:call)

        subject
      end
    end

    shared_examples 'returns correct status' do
      it do
        subject
        expect(response.status).to eq(expected_status)
      end
    end

    let(:income_params) do
      {
        first_name: 'John',
        last_name: 'Doe'
      }
    end
    let(:user_identifier_instance_double) do
      instance_double(UserIdentifierService, call: result)
    end
    let(:wrapped_params) do
      ActionController::Parameters.new(income_params).permit!
    end

    subject { get :show, params: income_params }

    before do
      allow(UserIdentifierService)
        .to receive(:new)
        .and_return(user_identifier_instance_double)
    end

    context 'when request is successful' do
      let(:user_id) { SecureRandom.uuid }
      let(:output) { { id: user_id } }
      let(:expected_status) { 200 }
      let(:result) do
        UserIdentifierService::Result.new(success: true, output: output, status: expected_status)
      end

      it_behaves_like 'returns correct status'

      it_behaves_like 'call UserIdentifierService once'

      it 'returns correct body' do
        subject
        expect(parsed_response).to eq(output)
      end
    end

    context 'when request is not successful' do
      let(:expected_err_msg) { 'msg' }
      let(:expected_status) { 404 }
      let(:result) do
        UserIdentifierService::Result.new(
          success: false,
          error_msg: expected_err_msg,
          status: expected_status
        )
      end

      it_behaves_like 'returns correct status'

      it_behaves_like 'call UserIdentifierService once'

      it 'returns error message' do
        subject
        expect(parsed_response[:message]).to eq(expected_err_msg)
      end
    end
  end
end
