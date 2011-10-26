class ApplicationController < ActionController::Base

  protect_from_forgery

  require "custom_strings.rb"

  def after_sign_in_path_for(resource)
		if resource.is_a?(User)
   		"/admin"
   	end
  end




end

