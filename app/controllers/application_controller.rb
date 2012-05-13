class ApplicationController < ActionController::Base

  protect_from_forgery

  require "custom_strings.rb"

  $domain="http://www.mydomain.com"
  $title="Domain"

  def after_sign_in_path_for(resource)
		if resource.is_a?(User)
   		"/admin"
   	end
  end

  def render_404
    respond_to do |format|
      format.html { render :file => "#{Rails.root}/public/404.html", :layout => false, :status => :not_found }
      format.xml  { head :not_found }
      format.any  { head :not_found }
    end
  end


end

