require 'rails_helper'

feature 'User can edit his question' do 
  given!(:user) { create(:user) }
  given(:user_not_author) { create(:user) }
  given!(:question) { create(:question, author: user) }

  describe 'Authenticated user', js: true do 

    background do 
      signin(user)
      visit question_path(question)
    end

    scenario 'can edit his question' do 

      within '.question' do
        click_on 'Edit question'
        fill_in 'Your title', with: 'update title'
        fill_in 'Your question', with: 'update question'
        click_on 'Save question'

        expect(page).to_not have_content question.title
        expect(page).to_not have_content question.body
        expect(page).to have_content 'update title'
        expect(page).to have_content 'update question'
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'can not edits his question' do 

      within '.question' do
        click_on 'Edit question'
        fill_in 'Your title', with: ''
        fill_in 'Your question', with: ''
        click_on 'Save question'

        expect(page).to have_content "Title can't be blank"
        expect(page).to have_content "Body can't be blank"
        expect(page).to have_content question.title
        expect(page).to have_content question.body
        expect(page).to have_selector 'textarea' 
      end
    end
  end

  scenario 'Authenticated user tries edit other users question' do 
    signin(user_not_author)
    visit question_path(question)
    
    expect(page).to_not have_link 'Edit question'
  end

  scenario 'Unauthenticated user can not edit question' do 
    visit question_path(question)
    expect(page).to_not have_link 'Edit question'
  end
end
