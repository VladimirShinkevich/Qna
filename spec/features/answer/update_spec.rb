# frozen_string_literal: true

require 'rails_helper'

feature 'User can edit his answer' do
  given!(:user) { create(:user) }
  given(:user_not_author) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question, author: user) }

  scenario 'Unauthenticated user can not edit answer' do
    visit question_path(question)
    expect(page).to_not have_link 'Edit'
  end

  describe 'Authenticated user', js: true do
    background do
      signin(user)
      visit question_path(question)
    end

    scenario 'can edits his answer' do
      click_on 'Edit'
      within '.answers' do
        fill_in 'Your answer', with: 'edited answer'
        click_on 'Save'

        expect(page).to_not have_content answer.body
        expect(page).to have_content 'edited answer'
      end
    end

    scenario 'can not edits his answer with errors' do
      click_on 'Edit'
      within '.answers' do
        fill_in 'Your answer', with: ''
        click_on 'Save'

        expect(page).to have_content "Body can't be blank"
        expect(page).to have_content answer.body
        expect(page).to have_selector 'textarea'
      end
    end

    scenario 'edit answer with attached files' do
      click_on 'Edit'

      within '.answers' do
        fill_in 'Your answer', with: 'edited answer'

        attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]

        click_on 'Save'

        expect(page).to_not have_content answer.body
        expect(page).to have_content 'edited answer'
        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'
      end
    end

    scenario 'edit answer with links' do
      within '.answers' do
        click_on 'Edit'

        fill_in 'Your answer', with: 'edited answer'

        click_on 'add link'

        fill_in 'Name', with: 'Yandex'
        fill_in 'Url', with: 'http://yandex.ru'

        click_on 'Save'

        expect(page).to have_link 'Yandex', href: 'http://yandex.ru'
      end
    end
  end

  scenario 'Authenticated user tries edit other users answer' do
    signin(user_not_author)
    visit question_path(question)
    within '.answers' do
      expect(page).to_not have_link 'Edit'
    end
  end
end
