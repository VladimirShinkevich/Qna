require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:answer) { create(:answer) }
  let(:question) { create(:question) }
  let(:user) { create(:user)}
  
  before { login(user) }

  describe 'POST #create' do 

    context 'with valid attributes' do 
      it 'saves new Answer in database' do 
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer) } }.to change(question.answers, :count).by(1)
      end

      it 'redirect to @question' do 
        post :create, params: { question_id: question, answer: attributes_for(:answer) }
        expect(response).to redirect_to assigns(:answer)
      end
    end

    context 'with invalid attributes' do 
      it 'does not save a new Answer in database' do 
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid) } }.to_not change(question.answers, :count)
      end

      it 'render new view' do 
        post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid) }
        expect(response).to render_template "questions/show"
      end
    end
  end

  describe 'DELETE #destroy' do 

    context 'is author' do 
      let!(:answer) { create(:answer) }
      let (:user) { answer.author }

      before { login(user) }

      it 'delete question from database' do 
        expect { delete :destroy, params: { id: answer } }.to change(Answer, :count).by(-1)
      end

      it 'redirect to show ' do 
        delete :destroy, params: { id: answer }
        expect(response).to redirect_to question_path(answer.question)
      end
    end

    context "is't author" do 
      let!(:answer) { create(:answer) }
      let!(:question) { create(:question) }

      it "can't delete question from database" do 
        expect { delete :destroy, params: { id: answer } }.to_not change(Answer, :count)
      end

      it 'edirect to show' do 
        delete :destroy, params: { id: answer }
        expect(response).to redirect_to question_path(answer.question)
      end
    end
  end
end
