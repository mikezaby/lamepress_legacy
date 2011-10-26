class Admin::BaseController < ApplicationController

  before_filter :authenticate_user!

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to admin_path, :alert => exception.message
  end

  #



	layout :compute_layout
	def compute_layout
  	action_name ==  "show" ?  "base" : "admin_html5"
	end


  def index
  end

end

