# frozen_string_literal: true

require 'rails_helper'

feature 'User can watch all questions' do
  given!(:questions) { create_list(:question, 3) }

  scenario ' get all questions' do
    visit questions_path

    expect(page).to have_content 'List of Questions'
    expect(questions.size).to eq Question.count
  end
end
