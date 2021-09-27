require 'rails_helper'

feature 'User Registration' do 

  scenario 'User tries registrated with valid attributes' do 
    visit new_user_registration_path
    fill_in 'Email', with: attributes_for(:user)[:email]
    fill_in 'Password', with: attributes_for(:user)[:password]
    fill_in 'Password confirmation', with: attributes_for(:user)[:password_confirmation]

    click_on 'Sign up'
    expect(page).to have_content 'Welcome! You have signed up successfully.'
  end

  scenario 'User tries registrated with invalid attributes' do 
    visit new_user_registration_path
    fill_in 'Email', with: attributes_for(:user, :invalid)[:email]
    fill_in 'Password', with: attributes_for(:user, :invalid)[:password]
    fill_in 'Password confirmation', with: attributes_for(:user, :invalid)[:password_confirmation]

    click_on 'Sign up'
    expect(page).to have_content "Email can't be blank"
    expect(page).to have_content "Password can't be blank"
  end

  let(:user) { create(:user) }

  scenario 'Authentificated user tries to registrated again' do 
    visit new_user_registration_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    fill_in 'Password confirmation', with: user.password_confirmation

    click_on 'Sign up'
    expect(page).to have_content 'Email has already been taken'
  end
end
