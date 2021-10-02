require 'rails_helper'

feature 'User tries delete question' do 

  describe 'Authenticated user tries delete question' do
    
    describe 'Auth user ' do 
      given(:user) { create(:user_with_questions) }

      background do 
        signin(user)
        visit question_path(user.questions.first)
        click_on "Delete question"
      end

      scenario 'is author of question' do 
        expect(page).to have_content "You question was successfuly deleted!"
      end
    end

    describe 'Auth user ' do 
      given(:question) { create(:question) }
      given(:user) { create(:user) }

      background do 
        signin(user)
        visit question_path(question)
      end

      scenario 'is not a author of question' do 
        expect(page).to_not have_link "Delete question"
      end
    end
  end

  describe 'Unauthenticated user' do 
    given(:question) { create(:question) }
   
    scenario 'tries delete question' do 
      visit question_path(question)
      
      expect(page).to_not have_link "Delete question"
    end
  end
end
