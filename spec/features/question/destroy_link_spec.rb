require 'rails_helper'

feature 'User can delete links' do 

  given!(:user_author) { create(:user)}
  given(:user) { create(:user) }
  given(:question) { create(:question, :with_link, author: user_author) }

  describe 'Auth user', js: true do
    scenario 'author of question can delete links' do 
      signin(user_author)
      visit question_path(question)

      click_on 'Delete link'
      expect(page).to_not have_link 'Delete link'
    end

    scenario 'can not delete links' do 
      signin(user)
      visit question_path(question)

      expect(page).to_not have_link 'Delete link'
    end
  end

  scenario 'Unauthenticated user can not delete links' do 
    visit question_path(question)

    expect(page).to_not have_link 'Delete link'
  end
end
