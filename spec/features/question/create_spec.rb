require 'rails_helper'

feature 'User can create question' do
  
  given(:user) { create(:user) }

  describe 'Authenticated user' do 

    background do 
      signin(user)

      visit questions_path
      click_on 'Ask question'
    end

    scenario 'user can asks a question' do 
      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'text text text'
      click_on 'Ask'

      expect(page).to have_content "Your question successfuly created."
      expect(page).to have_content 'Test question'
      expect(page).to have_content 'text text text'
    end

    scenario 'asks a question with errors' do 
      click_on 'Ask'

      expect(page).to have_content "Title can't be blank"
    end
  end

  scenario 'Unauthenticated user tries to ask question' do 
    visit questions_path
    click_on 'Ask question'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end