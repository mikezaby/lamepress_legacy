class ApplicationController < ActionController::Base

  protect_from_forgery

  before_filter :fetch_url

  $domain = LP_CONFIG["domain"]
  $title = LP_CONFIG["title"]
  $layout = Rails.env == "test" ? "demo" : LP_CONFIG["layout"]

  rescue_from ActiveRecord::RecordNotFound, with: :render_404

  def after_sign_in_path_for(resource)
    if resource.is_a?(User)
       "/admin"
     end
  end

  def render_404
    respond_to do |format|
      format.html { render file: "#{Rails.root}/public/404", layout: false,
                           status: :not_found }
      format.xml  { head :not_found }
      format.any  { head :not_found }
    end
  end

  def ckeditor_authenticate
    authorize! action_name, Ckeditor::Asset
  end

  def fetch_url
    @url = CGI::unescape(request.path.strip.gsub(/[\']|[\`]|[\"]/,""))
  end

  def fetch_issue
    @issue = if params[:number].present?
      Issue.published_only.find_by_number!(params[:number])
    else
      Setting.current_issue
    end
  end

end

