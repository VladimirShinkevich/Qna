require 'rails_helper'

feature 'User can mark answer as best', js: true do
  describe 'authenticated user' do
    given(:question) { create(:question) }
    given(:user) { question.author }
    given!(:answer1) { create(:answer, question: question) }
    given!(:answer2) { create(:answer, question: question) }

    background do
      signin(user)
      visit question_path(question)
    end

    scenario 'marks as best' do
      within all('.make_best').last do
        click_on 'Best Answer!'
      end

      expect(page).to have_content 'The Best answer'
      expect(first('.answers')).to have_content answer2.body
    end
  end

  describe 'unauthenticated user' do
    given(:answer) { create(:answer) }
    given(:question) { answer.question }
    given(:user) { create(:user) }

    background do
      signin(user)
      visit question_path(question)
    end

    scenario 'does not mark as best' do
      expect(page).not_to have_content 'Best Answer!'
    end
  end
end
