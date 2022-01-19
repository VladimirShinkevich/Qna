# frozen_string_literal: true

class CreateComments < ActiveRecord::Migration[6.1]
  def change
    create_table :comments do |t|
      t.text :body
      t.references :author, foreign_key: { to_table: :users }, null: false
      t.references :commentable, polymorphic: true, index: true

      t.timestamps
    end
  end
end
