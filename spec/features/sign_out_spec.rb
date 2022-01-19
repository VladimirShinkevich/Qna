# frozen_string_literal: true

require 'rails_helper'

feature 'User sign out' do
  let(:user) { create(:user) }
  before { signin(user) }

  scenario 'Authenticated user can sign out' do
    click_on 'Sign out'
    expect(page).to have_content 'Signed out successfully.'
  end
end
