class ApplicationController < ActionController::Base
	before_action :set_gon_user, unless: :devise_controller? 
	
	include Pundit


  rescue_from Pundit::NotAuthorizedError do |exception|
	  redirect_to root_url, alert: exception.message
	end	

	private 

	def set_gon_user
		gon.current_user_id = current_user.id if current_user
	end
end
