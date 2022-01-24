class AnswerSerializer < ActiveModel::Serializer
  attributes :id, :body, :created_at, :updated_at, :author_id, :question_id

  belongs_to :author, class_name: 'User'
  belongs_to :question
  has_many :links
  has_many :files 
  has_many :comments
end
