require 'rails_helper'

feature 'User delete answer' do 

  describe 'Authenticated user tries delete answer', js: true do 
    describe 'Auth user' do
      given(:user) { create(:user) }
      given(:question) { create(:question, author: user) }
      given!(:answer) { create(:answer, question: question, author: user, body: 'some text') }

      background { signin(user) }

      scenario 'is author of answer', js: true do 
        visit question_path(question)
        click_on 'Delete answer'
       
        expect(page).to_not have_content answer.body
      end
    end

    describe 'Auth user' do 
      given(:answer) { create(:answer) }
      given(:user) { create(:user) }
      given(:question) { answer.question }

      background { signin(user) }

      scenario 'is not a author of answer' do 
        visit question_path(question)

        expect(page).to_not have_link "Delete answer"
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
