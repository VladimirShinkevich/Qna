shared_examples_for 'API Create Object' do
  it_behaves_like 'API authorizable' do
    let(:method) { :post }
  end
  context 'authorized' do
    before { post api_url, params: params.merge({ access_token: access_token.token }), headers: headers }

    it_behaves_like 'API success'

    it_behaves_like 'API Check Fields' do
      let(:content_object) { new_object }
      let(:content_object_json) { object_json }
    end

    it 'contains user object' do
      expect(object_json['author']['id']).to eq access_token.resource_owner_id
    end
  end
end
