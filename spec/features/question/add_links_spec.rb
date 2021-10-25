require 'rails_helper'

feature 'User can add links to question' do

  given(:user) { create(:user) }
  given(:question) { create(:question, author: user) }
  given(:gist_url) { 'https://gist.github.com/VladimirShinkevich/a7ae7bc7fb4861fe58ad8e43d078ae5e' }

  scenario 'User adds links when asks question' do 
    signin(user)
    visit new_question_path

    fill_in 'Title', with: question.title
    fill_in 'Body', with: question.body

    fill_in 'Link name', with: 'My gist'
    fill_in 'Url', with: gist_url

    click_on 'Ask'

    expect(page).to have_link 'My gist', href: gist_url
  end
end