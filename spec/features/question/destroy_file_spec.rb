require 'rails_helper'

feature 'User delete files' do 
  given!(:user_author) { create(:user)}
  given(:user) { create(:user) }
  given!(:question) { create(:question, :question_with_files, author: user_author) }

  describe 'Auth user', js: true do 
    
    scenario 'author of question' do 
      signin(user_author)
      visit question_path(question)

      within '.file' do
        expect(page).to have_link 'rails_helper.rb' 
        click_on 'Delete file'
      end   

      expect(page).to_not have_link 'rails_helper.rb'
    end

    scenario 'not author of question' do 
      signin(user)
      visit question_path(question)

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to_not have_link 'Delete file'
    end
  end

  scenario 'Unauthenticated user can not delete files' do 
    visit question_path(question)

    expect(page).to_not have_link 'Delete file'
  end
end
