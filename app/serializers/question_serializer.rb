# frozen_string_literal: true

class QuestionSerializer < ActiveModel::Serializer
  attributes :id, :title, :body, :created_at, :updated_at, :short_title
  belongs_to :author, class_name: 'User'
  has_many :answers
  has_many :files
  has_many :links
  has_many :comments

  def short_title
    object.title.truncate(7)
  end
end
