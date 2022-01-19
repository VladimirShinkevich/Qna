# frozen_string_literal: true

require 'rails_helper'

feature 'User can add links to answer' do
  given(:user) { create(:user) }
  given!(:question) { create(:question) }
  given(:answer) { create(:answer) }
  given(:gist_url) { 'https://gist.github.com/VladimirShinkevich/a7ae7bc7fb4861fe58ad8e43d078ae5e' }
  given(:google_link) { 'http://google.ru' }

  describe 'Authenticated user', js: true do
    background do
      signin(user)
      visit question_path(question)

      fill_in 'Your answer', with: answer.body
    end

    scenario 'adds links when asks answer' do
      fill_in 'Link', with: 'My link'
      fill_in 'Url', with: gist_url

      click_on 'Create answer'

      within '.answers' do
        expect(page).to have_link 'My link', href: gist_url
      end
    end

    scenario 'adds more than one link to answer' do
      click_on 'add link'

      page.all(:fillable_field, 'Link').first.set('My gist')
      page.all(:fillable_field, 'Url').first.set(gist_url)
      page.all(:fillable_field, 'Link').last.set('Google')
      page.all(:fillable_field, 'Url').last.set(google_link)

      click_on 'Create answer'

      within '.answers' do
        expect(page).to have_link 'My gist', href: gist_url
        expect(page).to have_link 'Google', href: google_link
      end
    end
  end

  scenario 'Unauthenticated user tries to add answer links ' do
    visit questions_path

    expect(page).to_not have_link 'Create answer'
  end
end
