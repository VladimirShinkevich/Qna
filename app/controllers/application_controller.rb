# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :set_gon_user, unless: :devise_controller?

  include Pundit

  rescue_from Pundit::NotAuthorizedError do |_exception|
    head :forbidden
  end

  private

  def set_gon_user
    gon.current_user_id = current_user.id if current_user
  end
end
