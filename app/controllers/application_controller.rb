class ApplicationController < ActionController::Base

  protect_from_forgery

  require "custom_strings.rb"

  $domain = LP_CONFIG["domain"]
  $title = LP_CONFIG["title"]
  $layout = Rails.env == "test" ? "demo" : LP_CONFIG["layout"]

  rescue_from ActiveRecord::RecordNotFound, :with => :render_404

  def after_sign_in_path_for(resource)
    if resource.is_a?(User)
       "/admin"
     end
  end

  def render_404
    respond_to do |format|
      format.html { render :file => "#{Rails.root}/public/404", :layout => false, :status => :not_found }
      format.xml  { head :not_found }
      format.any  { head :not_found }
    end
  end

  def ckeditor_authenticate
    authorize! action_name, Ckeditor::Asset
  end

  def fetch_issue
    @issue = Issue.get_public_issue(params[:number]).first if params[:number].present?
    @issue ||= Setting.current_issue
    @issue ||= Issue.order('number DESC').published_only.limit(1).first
  end

end

