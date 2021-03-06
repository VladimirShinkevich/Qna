# frozen_string_literal: true

require 'rails_helper'

describe 'Profiles API', type: :request do
  let(:headers) { { 'ACCEPT' => 'application/json' } }

  describe 'GET/api/v1/profiles/me' do
    let(:method) { :get }
    let(:api_url) { '/api/v1/profiles/me' }

    it_behaves_like 'API authorizable'

    context 'authorize' do
      let(:me) { create(:user, admin: true) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }

      before { get api_url, params: { access_token: access_token.token }, headers: headers }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns all public fields' do
        %w[id email created_at updated_at].each do |attr|
          expect(json['user'][attr]).to eq me.send(attr).as_json
        end
      end

      it 'does not return private fields' do
        %w[password encrypted_password].each do |attr|
          expect(json).to_not have_key(attr)
        end
      end
    end
  end

  describe 'GET/api/v1/profiles' do
    let(:method) { :get }
    let(:api_url) { '/api/v1/profiles/' }

    it_behaves_like 'API authorizable'

    context 'authorize' do
      let!(:users) { create_list(:user, 3) }
      let(:me) { create(:user, admin: true) }
      let(:user) { users.first }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }

      before { get api_url, params: { access_token: access_token.token }, headers: headers }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'return list of users' do
        expect(json['users'].size).to eq users.count
      end

      it 'returns all public fields' do
        %w[id email admin created_at updated_at].each do |attr|
          expect(json['users'].first[attr]).to eq user.send(attr).as_json
        end
      end

      it 'does not return private fields' do
        %w[password encrypted_password].each do |attr|
          expect(json).to_not have_key(attr)
        end
      end
    end
  end
end
