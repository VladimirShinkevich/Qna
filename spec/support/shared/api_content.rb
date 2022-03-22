# frozen_string_literal: true

shared_examples_for 'API Content' do
  it 'returns list of content' do
    expect(object_json[content_name].size).to eq size
  end

  it 'contains author object' do
    expect(author_json).to eq author.id
  end

  it_behaves_like 'API Check Fields' do
    let(:attributs) { content_attr }
    let(:content_object_json) { content_json }
    let(:content_object) { content }
  end
end
