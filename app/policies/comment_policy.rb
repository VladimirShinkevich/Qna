# frozen_string_literal: true

class CommentPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def create?
    user&.admin? || user
  end
end
