# frozen_string_literal: true

require 'rails_helper'

feature 'User auth from facebook' do
  background { visit new_user_session_path }

  describe 'Sign in with facebook' do
    background { mock_auth_hash(:facebook) }

    scenario 'user can sign in with Github account' do
      click_on 'Sign in with Facebook'
      expect(page).to have_content 'Successfully authenticated from Facebook account.'
      expect(page).to have_content 'Sign out'
    end

    scenario 'can handle authentication error' do
      OmniAuth.config.mock_auth[:facebook] = :invalid_credentials
      click_on 'Sign in with Facebook'
      expect(page).to have_content('Could not authenticate you from Facebook')
    end
  end
end
