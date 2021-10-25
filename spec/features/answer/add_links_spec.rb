require 'rails_helper'

feature 'User can add links to answer' do

  given(:user) { create(:user) }
  given!(:question) { create(:question) }
  given(:answer) { create(:answer) }
  given(:gist_url) { 'https://gist.github.com/VladimirShinkevich/a7ae7bc7fb4861fe58ad8e43d078ae5e' }

  scenario 'User adds links when asks answer', js: true do 
    signin(user)
    visit question_path(question)

    #save_and_open_page

    fill_in 'Your answer', with: answer.body

    fill_in 'My link', with: 'My link'
    fill_in 'Url', with: gist_url

    click_on 'Create answer'

    within '.answers' do
      expect(page).to have_link 'My link', href: gist_url
    end
  end
end
