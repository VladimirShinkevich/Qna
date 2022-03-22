# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable, :trackable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :validatable, :omniauthable, omniauth_providers: %i[github facebook]

  has_many :questions, foreign_key: 'author_id', dependent: :destroy
  has_many :answers, foreign_key: 'author_id', dependent: :destroy
  has_many :awards, dependent: :destroy
  has_many :votes, foreign_key: 'author_id', dependent: :destroy
  has_many :comments, foreign_key: 'author_id', dependent: :destroy
  has_many :authorizations, dependent: :destroy
  has_many :subscriptions, dependent: :destroy

  def find_vote(votable)
    Vote.find_by(author_id: id, votable_id: votable.id, votable_type: votable.class.name)
  end

  def self.find_for_oauth(auth)
    FindForOauth.new(auth).call
  end

  def author_of?(resource)
    id == resource&.author_id
  end

  def create_authorization(auth)
    authorizations.create(provider: auth.provider, uid: auth.uid)
  end

  def subscribed?(record)
    record.subscriptions.where(user_id: id).any?
  end
end
