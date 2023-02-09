# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'PUT /users/deposit', type: :request do
  let(:endpoint) { "/users/deposit" }
  let(:user) { User.create(name: 'Teste', username: 'username', role: 1,
                           password: 'password', deposit: 10, role: 'buyer') }
  let(:product) { Product.create(name: 'Test Product', amount_available: 1, cost: 5, user: user) }

  before do
    allow(JsonWebTokenService).to receive(:decode).with(any_args).and_return({ user_id: user.id })
  end

    context 'expected behavior' do
      let(:params) { { deposit: 10 } }

      it 'responds with a status of 200 ok' do
        put endpoint, params: params

        expect(response).to have_http_status(:ok)
      end

      it 'updates user deposit' do
        put endpoint, params: params

        old_deposit_value = user.deposit
        expect(user.reload.deposit).to eq(old_deposit_value + params[:deposit])
      end
    end

    context 'expected exceptions' do
      let(:params) { { deposit: 12 } }

      it 'when amount not allowed' do
        user.update(deposit: 0)
        put endpoint, params: params

        expect(response.status).to eq(400)
        expect(JSON.parse(response.body)['error']).to eq('Amount not allowed, please deposit 5, 10, 20, 50 and 100 cent')
      end
    end
end
