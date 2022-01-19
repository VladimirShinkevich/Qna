# frozen_string_literal: true

class ChangeColumnNullToQuestion < ActiveRecord::Migration[6.1]
  def change
    change_column_null :questions, :title, false
    change_column_null :questions, :body, false
  end
end
