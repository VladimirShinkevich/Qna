class CreateVotes < ActiveRecord::Migration[6.1]
  def change
    create_table :votes do |t|
      t.integer :status, null: false, default: 1
      t.references :author, foreign_key: { to_table: :users }, null: false
      t.references :votable, polymorphic: true, index: true

      t.timestamps
    end
  end
end
