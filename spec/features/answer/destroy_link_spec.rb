# frozen_string_literal: true

require 'rails_helper'

feature 'User can delete links' do
  given!(:user_author) { create(:user) }
  given(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, :with_link, author: user_author, question: question) }

  describe 'Auth user', js: true do
    scenario 'author of answer can delete links' do
      signin(user_author)
      visit question_path(answer.question)

      within '.answer_links' do
        click_on 'Delete link'
      end

      expect(page).to_not have_link 'Google'
    end

    scenario 'can not delete links' do
      signin(user)
      visit question_path(answer.question)

      expect(page).to_not have_link 'Delete link'
    end
  end

  scenario 'Unauthenticated user can not delete links' do
    visit question_path(question)

    expect(page).to_not have_link 'Delete link'
  end
end
