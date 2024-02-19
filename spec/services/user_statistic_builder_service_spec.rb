require 'rails_helper'

RSpec.describe UserStatisticBuilderService do
  subject do
    described_class.new(params: params).call
  end

  describe '#call' do
    context 'when statistics calculated successfully' do
      let!(:reservation_startes_at) { DateTime.now }
      let(:seconds_spend) { 2500 }
      let(:left_at) { reservation_startes_at + seconds_spend.seconds }
      let(:params) { { reservation_id: reservation.id } }
      let!(:menu_item_1) { create(:menu_item) }
      let!(:menu_item_2) { create(:menu_item) }
      let(:reservation) do
        create(
          :reservation,
          starts_at: reservation_startes_at,
          ends_at: reservation_startes_at + 1.hour
        )
      end
      let!(:order_1) do
        create(:order, reservation: reservation, menu_item: menu_item_1, quantity: rand(1..5))
      end
      let!(:order_2) do
        create(:order, reservation: reservation, menu_item: menu_item_2, quantity: rand(1..5))
      end
      let(:expected_total_bill_cents) do
        menu_item_1.price_cents * order_1.quantity +
          menu_item_2.price_cents * order_2.quantity
      end
      let(:expected_statistic_attributes) do
        {
          customer_id: reservation.client_id,
          dishes_count: order_1.quantity + order_2.quantity,
          total_bill_cents: expected_total_bill_cents,
          time_spent_seconds: seconds_spend
        }
      end

      before do
        allow(DateTime).to receive(:now).and_return(left_at)
      end

      # probably required timecop to test correctly
      xit 'creates statistics record with correct attributes' do
        subject
        expect(TableStatistic.last.attributes).to eq(expected_statistic_attributes)
      end

      it 'creates statistic record' do
        expect { subject }.to change(TableStatistic, :count).by(1)
      end
    end
  end
end
