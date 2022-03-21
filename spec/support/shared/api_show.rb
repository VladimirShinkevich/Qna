shared_examples_for 'API Show' do
  it_behaves_like 'API authorizable' do
    let(:method) { :get }
  end
  context 'authorized' do
    let!(:comments) { create_list(:comment, 3, commentable: object) }
    let!(:link) { create(:link, linkable: object) }
    let!(:file) do
      object.files.attach(
        io: File.open("#{Rails.root}/spec/fixture/test_image.jpg"),
        filename: 'test_image.jpg'
      )
    end

    before { get api_url, params: { access_token: access_token.token }, headers: headers }

    it_behaves_like 'API success'

    it_behaves_like 'API Check Fields' do
      let(:attributs) { object_attr }
      let(:content_object_json) { object_json }
      let(:content_object) { object }
    end

    it 'contains user object' do
      expect(object_json['author']['id']).to eq object.author.id
    end
    describe 'comments' do
      it_behaves_like 'API Content' do
        let(:content_name) { 'comments' }
        let(:content) { comments.first }
        let(:content_json) { object_json['comments'].first }
        let(:author_json) { content_json['author_id'] }
        let(:author) { content.author }
        let(:size) { object.comments.size }
        let(:content_attr) { %w(id body author_id created_at updated_at) }
      end
    end

    describe 'files' do
      it_behaves_like 'API Content' do
        let(:content_name) { 'files' }
        let(:content) { object.files.first }
        let(:author_json) { object_json['author']['id'] }
        let(:author) { object.author }
        let(:content_json) { object_json['files'].first }
        let(:size) { object.files.size }
        let(:content_attr) { %w(id filename) }
      end
    end
    describe 'links' do
      it_behaves_like 'API Content' do
        let(:content_name) { 'links' }
        let(:content) { link }
        let(:author_json) { object_json['author']['id'] }
        let(:author) { object.author }
        let(:content_json) { object_json['links'].first }
        let(:size) { object.links.size }
        let(:content_attr) { %w(id name url) }
      end
    end
  end
end