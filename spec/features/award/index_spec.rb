# frozen_string_literal: true

require 'rails_helper'

feature 'Authenticated user can watch his awards' do
  given!(:user) { create(:user) }
  given!(:question) { create(:question, author: user) }
  given!(:answer) { create(:answer, question: question, author: user) }
  given!(:award) { create(:award, question: question) }

  scenario 'User views his rewards', js: true do
    signin user

    visit question_path(question)
    click_on 'Best Answer!'

    visit awards_path

    expect(page).to have_content award.name
    expect(page).to have_css("img[src*='test_image.jpg']")
  end

  scenario 'Unauthenticated user tries to watch awards' do
    visit root_path

    expect(page).to_not have_link 'My Awards'
  end
end
