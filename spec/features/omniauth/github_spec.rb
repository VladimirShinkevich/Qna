# frozen_string_literal: true

require 'rails_helper'

feature 'User auth from github' do
  background { visit new_user_session_path }

  describe 'Sign in with Github' do
    background { mock_auth_hash(:github) }

    scenario 'user can sign in with Github account' do
      click_on 'Sign in with GitHub'
      expect(page).to have_content 'Successfully authenticated from Github account.'
      # save_and_open_page
      expect(page).to have_content 'Sign out'
    end

    scenario 'can handle authentication error' do
      OmniAuth.config.mock_auth[:github] = :invalid_credentials
      click_on 'Sign in with GitHub'
      expect(page).to have_content('Could not authenticate you from GitHub')
    end
  end
end
