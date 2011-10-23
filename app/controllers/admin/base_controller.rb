class Admin::BaseController < ApplicationController
  before_filter :authenticate_user!
	layout :compute_layout
	def compute_layout
  	action_name ==  "show" ?  "base" : "admin_html5"
	end


  def index
  end

end

