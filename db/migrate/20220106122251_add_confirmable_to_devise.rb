# frozen_string_literal: true

class AddConfirmableToDevise < ActiveRecord::Migration[6.1]
  def change
    change_table :users do |t|
      t.string   :confirmation_token
      t.datetime :confirmed_at
      t.datetime :confirmation_sent_at
      t.string   :unconfirmed_email # Only if using reconfirmable
    end

    add_index :users, :confirmation_token, unique: true

    User.update_all(confirmed_at: DateTime.now)
  end
end
