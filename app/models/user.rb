class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :questions, foreign_key: 'author_id',  dependent: :destroy
  has_many :answers, foreign_key: 'author_id', dependent: :destroy
  has_many :awards, dependent: :destroy
  has_many :votes, foreign_key: 'author_id', dependent: :destroy
  has_many :comments, foreign_key: 'author_id', dependent: :destroy

  def author_of?(resource)
    resource&.author_id == id
  end

  def find_vote(votable)
    Vote.find_by(author_id: id, votable_id: votable.id, votable_type: votable.class.name)
  end
end
