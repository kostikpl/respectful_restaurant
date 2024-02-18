require 'rails_helper'

RSpec.describe CreateReservationService do
  subject do
    described_class.new(params: params).call
  end
  let(:client_id) { rand(1..100) }
  let(:table_id) { rand(1..100) }
  let(:starts_at) do
    DateTime.now + (CreateReservationService::RESERVATION_REQUIERD_HOURS_AHEAD + 2).hours
  end
  let(:ends_at) { starts_at + 2.hours }
  let(:menu_item_id) { create(:menu_item).id }
  let(:orders_params) { { quantity: rand(1..10), menu_item_id: menu_item_id } }
  let(:params) do
    {
      starts_at:starts_at,
      ends_at: ends_at,
      client_id: client_id,
      table_id: table_id,
      orders_attributes: [orders_params]
    }
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

  context 'when reservation created successfully' do
    let(:expected_status) { 201 }

    it_behaves_like 'returns correct status'

    it 'returns successfull result' do
      expect(subject.success?).to be_truthy
    end

    it 'creates reservation' do
      expect { subject }.to change(Reservation, :count).by(1)
    end
  end

  context 'when reservation was not created' do
    let(:expected_status) { 400 }

    xcontext 'when user not exists' do
    end

    xcontext 'when table not exists' do
    end

    context 'when reservation ends later than starts' do
      let(:starts_at) do
        CreateReservationService::RESERVATION_REQUIERD_HOURS_AHEAD.hours.from_now + 1.hour
      end
      let(:ends_at) { starts_at - 1.minute }

      it_behaves_like 'returns unsuccessful result'
      it_behaves_like 'returns error message'
      it_behaves_like 'returns correct status'
    end

    context 'when reservation starts too soon' do
      let(:starts_at) do
        CreateReservationService::RESERVATION_REQUIERD_HOURS_AHEAD.hours.from_now - 1.minute
      end

      it_behaves_like 'returns unsuccessful result'
      it_behaves_like 'returns error message'
      it_behaves_like 'returns correct status'
    end

    context 'when other reservation exists on selected time' do
      let!(:other_reservation) do
        create(:reservation, starts_at: ends_at - 1.second, ends_at: ends_at + 2.hours)
      end

      it_behaves_like 'returns unsuccessful result'
      it_behaves_like 'returns error message'
      it_behaves_like 'returns correct status'
    end

    context 'when menu item has negative quantity' do
      let(:orders_params) do
        {
          quantity: -1,
          menu_item_id: menu_item_id + rand(10..20)
        }
      end

      it_behaves_like 'returns unsuccessful result'
      it_behaves_like 'returns error message'
      it_behaves_like 'returns correct status'
    end

    context 'when reservation includes non existsing menu item' do
      let(:orders_params) do
        {
          quantity: rand(1..10),
          menu_item_id: menu_item_id + rand(10..20)
        }
      end

      it_behaves_like 'returns unsuccessful result'
      it_behaves_like 'returns error message'
      it_behaves_like 'returns correct status'
    end
  end
end
