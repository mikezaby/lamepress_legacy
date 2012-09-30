class Admin::BaseController < ApplicationController

  before_filter :authenticate_user!

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to admin_path, :alert => exception.message
  end
  

  layout "admin"


  def index
  end

end

