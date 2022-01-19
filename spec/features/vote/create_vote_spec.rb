# frozen_string_literal: true

require 'rails_helper'

feature 'User can vote questions and answers' do
  given(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question) }

  given(:question_author) { create(:question, author: user) }
  given(:answer_author) { create(:answer, author: user) }

  describe 'Auth user (not author of resource)', js: true do
    background do
      signin(user)
      visit question_path(question)
    end

    scenario 'can vote questions' do
      within '.question' do
        expect(page).to have_link 'Like'
        expect(page).to have_link 'Dislike'
        click_on 'Like'
        expect(page).to_not have_link 'Like'
        expect(page).to_not have_link 'Dislike'
        expect(page).to have_content 'You like this question'
        expect(page).to have_content 'Current rating: 1'
      end
    end

    scenario 'can vote answers' do
      within '.answers' do
        expect(page).to have_link 'Like'
        expect(page).to have_link 'Dislike'
        click_on 'Like'
        expect(page).to_not have_link 'Like'
        expect(page).to_not have_link 'Dislike'
        expect(page).to have_content 'You like this answer'
        expect(page).to have_content 'Current rating: 1'
      end
    end
  end

  describe 'Auth user (author of resource)' do
    background do
      signin(user)
      visit question_path(question_author)
    end

    scenario 'can not vote his resource' do
      expect(page).to_not have_link 'Like'
      expect(page).to_not have_link 'Dislike'
    end
  end

  scenario 'Unauthenticated user can not any resource' do
    visit question_path(question)

    expect(page).to_not have_link 'Like'
    expect(page).to_not have_link 'Dislike'
  end
end
