# frozen_string_literal: true

class CommentSerializer < ActiveModel::Serializer
  attributes :id, :body, :author_id, :created_at, :updated_at

  belongs_to :author, class_name: 'User'
end
