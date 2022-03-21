shared_examples_for 'API success' do 
  it 'return 200 status' do 
    expect(response).to be_successful
  end
end
