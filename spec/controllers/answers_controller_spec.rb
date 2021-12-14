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

      it "broadcasts to answers channel" do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer), format: :js } }.to have_broadcasted_to("question_#{question.id}").with(Answer.last)
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
        expect { delete :destroy, params: { id: answer }, format: :js }.to change(Answer, :count).by(-1)
      end

      it 'render destroy template ' do 
        delete :destroy, params: { id: answer }, format: :js
        expect(response).to render_template :destroy
      end
    end

    context "is't author" do 
      let!(:answer) { create(:answer) }
      let!(:question) { create(:question) }

      it "can't delete question from database" do 
        expect { delete :destroy, params: { id: answer }, format: :js }.to_not change(Answer, :count)
      end

      it 'render destroy template' do 
        delete :destroy, params: { id: answer }, format: :js
        expect(response).to render_template :destroy
      end
    end
  end

  describe 'POST #mark_as_best' do
    context 'when user is the author of question' do
      let(:question) { create(:question, :with_answers, author: user) }
      let(:answer) { question.answers.first }

      it 'has best answer' do
        patch :mark_as_best, params: { id: answer }, format: :js
        expect(question.reload.best_answer_id).to eq answer.id
      end

      it 'renders :mark_best view' do
        patch :mark_as_best, params: { id: answer }, format: :js
        expect(response).to render_template :mark_as_best
      end
    end

    context 'when user is not the author of question' do
      let(:question) { create(:question, :with_answers) }
      let(:answer) { question.answers.first }

      it 'has best answer' do
        patch :mark_as_best, params: { id: answer }, format: :js
        expect(question.best_answer_id).to eq nil
      end

      it 'renders mark_best view' do
        patch :mark_as_best, params: { id: answer }, format: :js
        expect(response).to render_template :mark_as_best
      end
    end
  end
end
