class Admin::BaseController < ApplicationController

  before_filter :authenticate_user!

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to admin_path, :alert => exception.message
  end

  

	layout :compute_layout
	
  def compute_layout
  	(action_name ==  "show" and controller_name == "Article") ?  "base" : "admin"
	end


  def index
  end

end

