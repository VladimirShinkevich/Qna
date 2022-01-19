# frozen_string_literal: true

class VotePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def destroy?
    user&.admin? || user&.author_of?(record)
  end
end
