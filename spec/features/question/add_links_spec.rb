# frozen_string_literal: true

require 'rails_helper'

feature 'User can add links to question' do
  given(:user) { create(:user) }
  given(:question) { create(:question, author: user) }
  given(:gist_url) { 'https://gist.github.com/VladimirShinkevich/a7ae7bc7fb4861fe58ad8e43d078ae5e' }
  given(:google_link) { 'http://google.ru' }

  describe 'Authenticated user', js: true do
    background do
      signin(user)
      visit new_question_path

      fill_in 'Title', with: question.title
      fill_in 'Body', with: question.body
    end

    scenario 'adds links when asks question' do
      # save_and_open_page
      fill_in 'Link', with: 'My gist'
      fill_in 'Url', with: gist_url

      click_on 'Ask'

      expect(page).to have_link 'My gist', href: gist_url
    end

    scenario 'adds more than one link to question' do
      click_on 'add link'

      page.all(:fillable_field, 'Link').first.set('My gist')
      page.all(:fillable_field, 'Url').first.set(gist_url)
      page.all(:fillable_field, 'Link').last.set('Google')
      page.all(:fillable_field, 'Url').last.set(google_link)

      click_on 'Ask'

      within '.question' do
        expect(page).to have_link 'My gist', href: gist_url
        expect(page).to have_link 'Google', href: google_link
      end
    end
  end

  scenario 'Unauthenticated user tries to add question links' do
    visit questions_path

    expect(page).to_not have_link 'Ask question'
  end
end
