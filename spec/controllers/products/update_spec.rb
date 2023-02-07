# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'PUT /products/:id', type: :request do
  let(:endpoint) { "/products/#{product.id}" }
  let(:user) { User.create(name: 'Teste', username: 'username', role: 0,
                           password: 'password', deposit: 10) }
  let(:product) { Product.create(name: 'Product 1', amount_available: 2, cost: 10, user: user)}

  let(:params) { {data: { name: 'Teste 2.0', username: 'username 2.0', role: '0', password: 'teste' }
  } }

  before do
    allow(JsonWebTokenService).to receive(:decode).with(any_args).and_return({ user_id: user.id })
  end

  context 'expected exceptions' do

    it 'User has to be Seller to perform that action' do
      put endpoint, params: params

      expect(response.status).to eq(401)
      expect(JSON.parse(response.body)['error']).to eq('User has to be Seller to perform that action')
    end
  end


end
