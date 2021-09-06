require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  describe 'GET #show' do 
    let(:question) { create(:question) }
    before { get :show, params: { id: question } }

    it 'assigns the requested question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'render show view' do
      expect(response).to render_template :show
    end
  end

  describe 'POST #create' do 
    context 'with valid attributes' do
      it 'saves new Question to database' do 
        expect { post :create, params: { question: attributes_for(:question) } }.to change(Question, :count).by(1)
      end

      it 'render show view' do 
        post :create, params: { question: attributes_for(:question) }
        expect(response).to render_template :show
      end
    end

    context 'with invalid attributes' do 
      it 'does not save Question to database' do 
        expect { post :create, params: { question: attributes_for(:question, :invalid) } }.to_not change(Question, :count)
      end

      it 'render new view' do 
        post :create, params: { question: attributes_for(:question, :invalid) }
        expect(response).to render_template :new
      end
    end
  end
end
