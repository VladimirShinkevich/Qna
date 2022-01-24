shared_examples_for 'API Delete object' do
  it_behaves_like 'API authorizable' do
    let(:method) { :delete }
  end
  context 'authorized' do
    before { delete api_url, params: { access_token: access_token.token }, headers: headers }

    it_behaves_like 'API success'

    it 'should not find objest' do
      expect(object_class.where(id: object.id).first).to be_nil
    end
  end
end
