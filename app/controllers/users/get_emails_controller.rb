# frozen_string_literal: true

module Users
  class GetEmailsController < ApplicationController
    def show; end

    def create
      auth = session[:auth]
      auth['info']['email'] = params[:email]
      user = User.find_for_oauth(Omniauth::AuthHash.new(auth))

      if user&.persisted?
        user.confirm_at = nil
        user.send_confirmation_instructions
        session[:auth] = nil
        redirect_to root_path, alert: 'You need to confirm email'
      else
        redirect_to users_get_email_path, alert: 'Something went wrong'
      end
    end
  end
end
