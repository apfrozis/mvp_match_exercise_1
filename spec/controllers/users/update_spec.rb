# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'PUT /users/:id', type: :request do
  let(:endpoint) { "/users//#{user.id}" }
  let(:user) { User.create(name: 'Teste', username: 'username', role: 1,
                           password: 'password', deposit: 10) }

  let(:params) { {data: { name: 'Teste 2.0', username: 'username 2.0', role: '0', password: 'teste' }
  } }

  before do
    allow(JsonWebTokenService).to receive(:decode).with(any_args).and_return({ user_id: user.id })
  end

  context 'with valid sessions' do

    it 'responds with a status of 200 ok' do
      put endpoint, params: params

      expect(response).to have_http_status(:ok)
    end

    it 'responds with correct info' do
      put endpoint, params: params

      # Removed password that does not go in the response and added deposit info
      expected_result = params[:data].merge({deposit: user.deposit}).except(:password)
      expect(JSON.parse(response.body).symbolize_keys).to eq(expected_result)
    end

    it 'updates password correctly' do
      put endpoint, params: params

      expect(user.reload.password).to eq(params[:data][:password])
    end
  end


end
