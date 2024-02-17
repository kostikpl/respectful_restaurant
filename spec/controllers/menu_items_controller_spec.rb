require 'rails_helper'

RSpec.describe MenuItemsController, type: :controller do
  include_context 'with parsed response'

  describe '#index' do
    shared_examples 'returns correct status' do
      it do
        subject
        expect(response.status).to eq(expected_status)
      end
    end

    shared_examples 'returns correct body' do
      it do
        subject
        expect(parsed_response).to eq(expected_response)
      end
    end

    context 'when request is successful' do
      subject { get :index }
      let(:expected_status) { 200 }

      context 'when menu items are present' do
        let!(:menu_item) { create(:menu_item) }
        let(:expected_response) do
          {
            data: [
              price_cents: menu_item.price_cents,
              title: menu_item.title
            ]
          }
        end

        it_behaves_like 'returns correct body'

        it_behaves_like 'returns correct status'
      end

      context 'when menu items are absent' do
        let(:expected_response) { { data: [] } }

        it_behaves_like 'returns correct body'

        it_behaves_like 'returns correct status'
      end
    end
  end
end
