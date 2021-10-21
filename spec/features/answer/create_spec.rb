require 'rails_helper'

feature 'User can create answer' do 

  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given(:answer) { create(:answer) }

  describe 'Authenticated user', js: true do 

    background do 
      signin(user)

      visit question_path(question)
    end

    scenario 'user tries to create a answer with valid attributes' do 
      fill_in 'Body', with: answer.body
      click_on 'Create answer'

      expect(page).to have_content answer.body
    end

    scenario 'user tries create answer with invalid attributes' do 
      click_on 'Create answer'

      expect(page).to have_content "Body can't be blank"
    end

    scenario 'ask answer with attached file' do 
      fill_in 'Body', with: answer.body

      attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
      click_on 'Create answer'
      
      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end
  end

  scenario 'Unregistreted user tries to create answer' do 
    visit question_path(question)
    click_on 'Create answer'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
