class Admin::IssueController < Admin::BaseController

  load_and_authorize_resource

  def index
    @issue = Issue.published_only.order("created_at DESC").page(params[:page]).per(20)
    @unpub_issue = Issue.unpublished_only.order("created_at Desc").
      page(params[:np_page]).per(20)
  end

  def new
  	@issue=Issue.new
  end

  def create
		@issue = Issue.new(params[:issue])
    if @issue.save
      redirect_to(admin_issues_path, :notice => 'Issue was successfully created.')
    else
      render :action => "new"
    end
  end

  def edit
  	@issue = Issue.find(params[:id])
  end

  def update
  	@issue = Issue.find(params[:id])
    if @issue.update_attributes(params[:issue])
      redirect_to(admin_issues_path, :notice => "The issue was successfully updated.")
    else
      render :action => "edit"
    end
  end

  def destroy
  	@issue = Issue.find(params[:id])
    @issue.destroy
    redirect_to(admin_issues_path)
  end


end

