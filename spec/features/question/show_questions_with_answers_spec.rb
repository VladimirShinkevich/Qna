require 'rails_helper'

feature 'User can see question with answers' do
  given(:question) { create(:question_with_answers)}

  scenario 'User view questions with answers' do 
    visit question_path(question)

    expect(page).to have_content question.title
    expect(page).to have_content question.body
    expect(page.all('li').size).to eq question.answers.count
  end
end
