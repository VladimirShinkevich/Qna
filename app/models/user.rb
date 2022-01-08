class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable, :trackable
  devise :database_authenticatable, :registerable, :confirmable, 
         :recoverable, :rememberable, :validatable, :omniauthable, omniauth_providers: [:github, :facebook]

  has_many :questions, foreign_key: 'author_id',  dependent: :destroy
  has_many :answers, foreign_key: 'author_id', dependent: :destroy
  has_many :awards, dependent: :destroy
  has_many :votes, foreign_key: 'author_id', dependent: :destroy
  has_many :comments, foreign_key: 'author_id', dependent: :destroy
  has_many :authorizations, dependent: :destroy

  def author_of?(resource)
    resource&.author_id == id
  end

  def find_vote(votable)
    Vote.find_by(author_id: id, votable_id: votable.id, votable_type: votable.class.name)
  end

  def self.find_for_oauth(auth)
    FindForOauth.new(auth).call
  end

  def create_authorization(auth)
    self.authorizations.create(provider: auth.provider, uid: auth.uid)
  end
end
