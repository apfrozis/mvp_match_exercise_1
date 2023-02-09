# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'PUT /users/buy', type: :request do
  let(:endpoint) { "/users/buy" }
  let(:user) { User.create(name: 'Test', username: 'username', role: 1,
                           password: 'password', deposit: 50, role: 'buyer') }
  let(:product) { Product.create(name: 'Test Product', amount_available: 1, cost: 5, user: user) }

  let(:params) { { products_amount: 1, product_id: product.id } }

  before do
    allow(JsonWebTokenService).to receive(:decode).with(any_args).and_return({ user_id: user.id })
  end

  context 'expected behavior' do

    it 'responds with a status of 200 ok' do
      put endpoint, params: params

      expect(response).to have_http_status(:ok)
    end

    it 'updates user deposit' do
      put endpoint, params: params

      old_deposit_value = user.deposit
      expect(user.reload.deposit).to eq(old_deposit_value - product.cost)
    end

    it 'updates amount available for product' do
      put endpoint, params: params

      old_amount_available_for_product = product.amount_available
      expect(product.reload.amount_available).to eq(old_amount_available_for_product - params[:products_amount])
    end

    it 'returns expected result' do
      put endpoint, params: params
      product.reload
      expected_result = { id: product.id, name: product.name, amount_available: product.amount_available, cost: product.cost,
                          user_name: product.user.name }.merge(amount_spent: params[:products_amount] * product.cost,
                                                               change: [20, 20, 5])
      expect(JSON.parse(response.body).symbolize_keys).to eq(expected_result)
    end
  end

  context 'expected exceptions' do

    it 'when not enough money to buy product/products' do
      user.update(deposit: 0)
      put endpoint, params: params

      expect(response.status).to eq(400)
      expect(JSON.parse(response.body)['error']).to eq('Not enough money to buy product/products')
    end

    it 'when not enough products available' do
      product.update(amount_available: 0)
      put endpoint, params: params

      expect(response.status).to eq(400)
      expect(JSON.parse(response.body)['error']).to eq('Not enough products available')
    end

    it "when amount is less than 0" do
      params[:products_amount] = -1
      put endpoint, params: params

      expect(response.status).to eq(400)
      expect(JSON.parse(response.body)['error']).to eq("Amount can't be less than 0")
    end
  end


end
