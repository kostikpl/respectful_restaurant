require 'rails_helper'

RSpec.describe ReservationsController, type: :controller do
  include_context 'with parsed response'
  include_context 'with response status'
  include_context 'with response body'


  describe '#create' do
    shared_examples 'call CreateReservationService once' do
      it do
        expect(CreateReservationService)
          .to receive(:new)
          .with(params: wrapped_params)
          .once

        expect(create_service_instance_double).to receive(:call)

        subject
      end
    end

    let(:incoming_params) do
      {
        client_id: SecureRandom.uuid,
        table_id: SecureRandom.uuid,
        starts_at: Time.now.utc.change(usec: 0),
        ends_at: Time.now.utc.change(usec: 0) + 2.hours
      }
    end
    let(:create_service_instance_double) do
      instance_double(CreateReservationService, call: result)
    end
    let(:wrapped_params) do
      ActionController::Parameters.new(incoming_params).permit!
    end

    subject { post :create, params: incoming_params }

    before do
      allow(CreateReservationService)
        .to receive(:new)
        .and_return(create_service_instance_double)
    end

    context 'when request is successful' do
      let(:expected_status) { 201 }
      let(:expected_response) { {} }
      let(:result) do
        CreateReservationService::Result.new(
          success: true,
          output: {},
          status: expected_status
        )
      end

      it_behaves_like 'returns correct body'
      it_behaves_like 'returns correct status'
      it_behaves_like 'call CreateReservationService once'
    end

    context 'when request is not successful' do
      # TODO: all negative cases can be extended, like params missing
      xcontext 'when required params are missing' do
      end

      context 'when reservation was not created' do
        let(:expected_status) { 400 }
        let(:result) do
          CreateReservationService::Result.new(
            success: false,
            error_msg: 'msg',
            status: expected_status
          )
        end

        it 'returns error message' do
          subject
          expect(parsed_response[:message]).to be_present
        end

        it_behaves_like 'returns correct status'
        it_behaves_like 'call CreateReservationService once'
      end
    end
  end
end
