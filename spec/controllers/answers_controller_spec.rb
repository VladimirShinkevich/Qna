require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:answer) { create(:answer) }
  let(:question) { create(:question) }
  let(:user) { create(:user)}
  
  before { login(user) }

  describe 'POST #create' do 

    context 'with valid attributes' do 
      it 'saves new Answer in database' do 
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer) }, format: :js }.to change(question.answers, :count).by(1)
      end

      it 'renders create template' do 
        post :create, params: { question_id: question, answer: attributes_for(:answer), format: :js }
        expect(response).to render_template :create
      end
    end

    context 'with invalid attributes' do 
      it 'does not save a new Answer in database' do 
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid) }, format: :js }.to_not change(question.answers, :count)
      end

      it 'renders create template' do 
        post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid), format: :js }
        expect(response).to render_template :create
      end
    end
  end

  describe "PATCH #update" do 
    let!(:answer) { create(:answer, question: question, author: user) }

    describe 'Authenticated user' do
      before { login(user) }

      context 'with valid attributes' do 
        it 'assigns the request answer to @answer' do 
          patch :update, params: { id: answer, answer: attributes_for(:answer), format: :js }
          expect(assigns(:answer)).to eq answer
        end

        it 'changes answer attributes' do 
          patch :update, params: { id: answer, answer: { body: 'new body'}, format: :js }
          answer.reload
          expect(answer.body).to eq "new body"
        end

        it 'render update template' do 
          patch :update, params: { id: answer, answer: { body: 'new body'} }, format: :js 
          expect(response).to render_template :update
        end
      end

      context 'with invalid attributes' do 
        it 'does not change answer attributes' do 
          expect do 
            patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js
          end.to_not change(answer, :body)
        end

        it 'render update template' do 
          patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js
          expect(response).to render_template :update
        end
      end
    end

    context 'Unauthenticated user ' do 
      it 'tries to update answer' do
        patch :update, params: { id: answer, answer: { body: 'new body'} }, format: :js
        answer.reload
        expect(answer.body).to eq answer.body
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
