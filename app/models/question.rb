class Question < ApplicationRecord
  has_many :answers, dependent: :destroy
  belongs_to :author, class_name: 'User'
  belongs_to :best_answer, class_name: 'Answer', optional: true

  validates :title, presence: true
  validates :body, presence: true

  def other_answers
    answers.where.not(id: best_answer_id)
  end
end
