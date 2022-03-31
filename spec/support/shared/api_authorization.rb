# frozen_string_literal: true

shared_examples_for 'API authorizable' do
  context 'unauthorized' do
    it 'return 401 status' do
      do_request(method, api_url, headers: headers)
      expect(response.status).to eq 401
    end

    it 'return 401 status if access_token invalid' do
      do_request(method, api_url, params: { access_token: '12345' }, headers: headers)
      expect(response.status).to eq 401
    end
  end
end
