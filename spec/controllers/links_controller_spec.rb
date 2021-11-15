require 'rails_helper'

RSpec.describe LinksController, type: :controller do

  describe "DELETE #destroy" do

    describe 'question link' do
      let(:user) { create(:user) }
      let(:user2) { create(:user) }
      let(:question) { create(:question, author: user) }
      let!(:link) { create(:link, linkable: question) }

      context 'Unauthenticated can not delete link' do
        it 'does not delete answer' do
          expect { delete :destroy, params: { id: link }, format: :js }.to_not change(Link, :count)
        end
      end

      context 'Author delete link from his question' do
        it 'deletes the question link' do
          login(user)
          expect { delete :destroy, params: { id: link }, format: :js }.to change(Link, :count).by(-1)
        end
      end

      context 'User try to delete link from not his question' do
        it 'deletes the question link' do
          login(user2)
          expect { delete :destroy, params: { id: link }, format: :js }.to_not change(Link, :count)
        end
      end
    end

    describe 'answer link' do
      let(:user) { create(:user) }
      let(:user2) { create(:user) }
      let(:answer) { create(:answer, author: user) }
      let!(:link) { create(:link, linkable: answer) }

      context 'Unauthenticated can not delete link' do
        it 'does not delete answer link' do
          expect { delete :destroy, params: { id: link }, format: :js }.to_not change(Link, :count)
        end
      end

      context 'Author delete link from his answer' do
        it 'deletes the question' do
          login(user)
          expect { delete :destroy, params: { id: link }, format: :js }.to change(Link, :count).by(-1)
        end
      end

      context 'User try to delete link from not his answer' do
        it 'deletes the answer link' do
          login(user2)
          expect { delete :destroy, params: { id: link }, format: :js }.to_not change(Link, :count)
        end
      end
    end
  end
end
