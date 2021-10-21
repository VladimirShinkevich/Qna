require 'rails_helper'

feature 'User can create question' do
  
  given(:user) { create(:user) }
  given(:question) { create(:question) }

  describe 'Authenticated user' do 

    background do 
      signin(user)

      visit questions_path
      click_on 'Ask question'
    end

    scenario 'user can asks a question' do 
      fill_in 'Title', with: question.title
      fill_in 'Body', with: question.body
      click_on 'Ask'

      expect(page).to have_content "Your question is successfuly created."
      expect(page).to have_content question.title
      expect(page).to have_content question.body
    end

    scenario 'asks a question with errors' do 
      click_on 'Ask'

      expect(page).to have_content "Title can't be blank"
    end

    scenario 'ask question with attached file' do 
      fill_in 'Title', with: question.title
      fill_in 'Body', with: question.body

      attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
      click_on 'Ask'

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end
  end

  scenario 'Unauthenticated user tries to ask question' do 
    visit questions_path
    click_on 'Ask question'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
