# frozen_string_literal: true

class AddReferenceQuestionBestAnswerToTableAnswers < ActiveRecord::Migration[6.1]
  def change
    add_reference :questions, :best_answer
  end
end
