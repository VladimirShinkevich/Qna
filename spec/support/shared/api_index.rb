# frozen_string_literal: true

shared_examples_for 'API Index' do
  it_behaves_like 'API authorizable' do
    let(:method) { :get }
  end

  context 'authorize' do
    before { get api_url, params: { access_token: access_token.token }, headers: headers }

    it_behaves_like 'API success'

    it 'return list of objects' do
      expect(objects_json.size).to eq size
    end

    it 'return all public fields' do
      object_attr.each do |attr|
        expect(object_json[attr]).to eq object.send(attr).as_json
      end
    end

    it 'return user object' do
      expect(object_json['author']['id']).to eq object.author.id
    end
  end
end
