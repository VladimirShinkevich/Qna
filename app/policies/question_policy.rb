# frozen_string_literal: true

class QuestionPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def index?
    true
  end

  def show?
    true
  end

  def create?
    user&.admin? || user
  end

  def update?
    user&.admin? || user&.author_of?(record)
  end

  def destroy?
    user&.admin? || user&.author_of?(record)
  end

  def vote?
    user&.admin? || !user&.author_of?(record)
  end
end
