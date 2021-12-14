require 'rails_helper'

feature 'User can create answer' do 

  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given(:answer) { create(:answer) }

  describe 'Authenticated user', js: true do 

    background do 
      signin(user)

      visit question_path(question)
    end

    scenario 'user tries to create a answer with valid attributes' do 
      fill_in 'Body', with: answer.body
      click_on 'Create answer'

      expect(page).to have_content answer.body
    end

    scenario 'user tries create answer with invalid attributes' do 
      click_on 'Create answer'

      expect(page).to have_content "Body can't be blank"
    end

    scenario 'ask answer with attached files' do 
      fill_in 'Body', with: answer.body

      attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
      click_on 'Create answer'
      
      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end
  end

  scenario 'Unregistreted user tries to create answer' do 
    visit question_path(question)
    
    expect(page).to_not have_link 'Create answer'
  end

  describe 'Multiple sessions', js: true do
    given(:user) { create(:user) }
    given(:question) { create(:question) }
    given(:other_question) { create :question }
    given(:another_user) { create :user }

    scenario "Answer appears on guests page" do
      Capybara.using_session('user') do
        signin(user)
        visit question_path(question)
      end

      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        within '.new_answer' do
          fill_in 'Body', with: 'Some text'
          attach_file 'Files', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]

          within '#links' do
            fill_in 'Link', with: 'Thinknetica'
            fill_in 'Url', with: 'https://thinknetica.com'
          end
          click_on 'Create answer'
        end
      end

      Capybara.using_session('guest') do
        within ".answers" do
          expect(page).to have_content 'Some text'
          expect(page).to have_content 'rails_helper.rb'
          expect(page).to have_content 'spec_helper.rb'
          expect(page).to have_link 'Thinknetica', href: 'https://thinknetica.com'
          expect(page).to have_no_link 'Best answer'
          #expect(page).to have_content 'Comments'
        end
      end
    end

    scenario "Answer appears on another user page" do
      Capybara.using_session('user') do
        signin(user)
        visit question_path(question)
      end

      Capybara.using_session('another_user') do
        signin(another_user)
        visit question_path(question)
      end

      Capybara.using_session('user') do
        within '.new_answer' do
          fill_in 'Body', with: 'Some text'
          click_on 'Create answer'
        end
      end

      Capybara.using_session('another_user') do
        within ".answers" do
          expect(page).to have_content 'Some text'
          expect(page).to have_no_link 'Best answer'
          #expect(page).to have_content 'Comments'
          #expect(page).to have_content 'New comment'
        end
      end
    end

    scenario "Answer don't appears on another question's page" do
      Capybara.using_session('user') do
        signin(user)
        visit question_path(question)
      end

      Capybara.using_session('other_question') do
        visit question_path(other_question)
      end

      Capybara.using_session('user') do
        within '.new_answer' do
          fill_in 'Body', with: 'Some text'
          click_on 'Create answer'
        end
      end

      Capybara.using_session('other_question') do
        expect(page).not_to have_content 'Some text'
      end
    end
  end
end
