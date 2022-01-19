# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AwardsController, type: :controller do
  describe 'GET #index' do
    let(:user) { create(:user) }
    let(:awards) { create_list(:award, 3) }

    before { login(user) }

    before { get :index }

    it 'show list of Awards' do
      expect(assigns(:awards)).to match_array(user.awards)
    end

    it 'render index vies' do
      expect(response).to render_template :index
    end
  end
end
