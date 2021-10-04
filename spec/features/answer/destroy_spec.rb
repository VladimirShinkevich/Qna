require 'rails_helper'

feature 'User delete answer' do 

  describe 'Authenticated user tries delete answer' do 
    describe 'Auth user' do
      given(:answer) { create(:answer) }
      given(:user) { answer.author }
      given(:question) { answer.question }

      background { signin(user) }

      scenario 'is author of answer' do 
        visit question_path(question)
        expect(page).to have_link 'delete answer'

        click_on 'delete answer'
        expect(page).to have_content "You answer if succefully deleted!"
      end
    end

    describe 'Auth user' do 
      given(:answer) { create(:answer) }
      given(:user) { create(:user) }
      given(:question) { answer.question }

      background { signin(user) }

      scenario 'is not a author of answer' do 
        visit question_path(question)

        expect(page).to_not have_link "delete answer"
      end
    end
  end

  describe 'Unauthenticated user' do 
    given(:answer) { create(:answer) }
    given(:question) { answer.question }

    scenario 'tries delete answer' do 
      visit question_path(question)

      expect(page).to_not have_link "delete answer"
    end
  end
end
