require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:question) { create(:question) }
  let(:user) { create(:user) }

  describe 'GET #index' do 
    let(:questions) { create_list(:question, 3) }

    before { get :index }

    it 'show list of Questions' do 
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'render index vies' do 
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do 
    before { get :show, params: { id: question } }

    it 'assigns the requested question to @question ' do 
      expect(assigns(:question)).to eq question
    end

    it 'render show view' do 
      expect(response).to render_template :show
    end

    it 'assigns new Answer to @answer' do 
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'assigns new link for answer' do
      expect(assigns(:answer).links.first).to be_a_new(Link)
    end
  end

  describe 'GET #new' do
    before { login(user) }

    before { get :new }

    it 'assigns a new Question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'assigns a new Link to @link' do
      expect(assigns(:question).links.first).to be_a_new(Link)
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do 
    before { login(user) }

    context 'with valid attributes' do
      it 'saves new Question to database' do 
        expect { post :create, params: { question: attributes_for(:question) } }.to change(Question, :count).by(1)
      end

      it 'redirect to show view' do 
        post :create, params: { question: attributes_for(:question) }
        expect(response).to redirect_to assigns(:question)
      end

      it "broadcasts to questions channel" do
        expect { post :create, params: { question: attributes_for(:question) } }.to have_broadcasted_to("questions").with(Question.last)
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

  describe 'PATCH #update' do 
    let!(:question) { create(:question, author: user) }

    describe 'Authenticated user' do 
      before { login(user) }

      context 'with valid attributes' do 
        it 'assigns the request question to @question' do 
          patch :update, params: { id: question, question: attributes_for(:question), format: :js }
          expect(assigns(:question)).to eq question
        end

        it 'change question attributes' do 
          patch :update, params: { id: question, question: { title: 'edit title', body: 'edit question'}, format: :js }
          question.reload
          expect(question.body).to eq 'edit question'
        end

        it 'render template update' do 
          patch :update, params: { id: question, question: { title: 'edit title', body: 'edit question'}, format: :js }
          expect(response).to render_template :update
        end
      end

      context 'with invalid attributes' do
        it 'does not change question attributes' do 
          expect do 
            patch :update, params: { id: question, question: attributes_for(:question, :invalid) }, format: :js
          end.to_not change(question, :body)
        end

        it 'render update template' do 
          patch :update, params: { id: question, question: attributes_for(:question, :invalid) }, format: :js
          expect(response).to render_template :update
        end
      end
    end

    context 'Unauthenticated user' do 
      it 'tries to update question' do
        patch :update, params: { id: question, question: { title: 'edit title', body: 'edit question'}, format: :js }
        question.reload
        expect(question.body).to eq question.body
      end
    end
  end

  describe 'DELETE #destroy' do 
    describe "Auth user" do 
      before { login(user) }

      context 'is author' do 
        let!(:question) { create(:question, author: user) }

        it 'delete question from database' do 
          expect { delete :destroy, params: { id: question } }.to change(Question, :count).by(-1)
        end

        it 'redirect to index ' do 
          delete :destroy, params: { id: question }
          expect(response).to redirect_to questions_path
        end
      end

      context "is't author" do 
        let!(:question) { create(:question) }

        it "can't delete question from database" do 
          expect { delete :destroy, params: { id: question } }.to_not change(Question, :count)
        end

        it 're render show' do 
          delete :destroy, params: { id: question }
          expect(response).to render_template :show
        end
      end
    end
  end
end
