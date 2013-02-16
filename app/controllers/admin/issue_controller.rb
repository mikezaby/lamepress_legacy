class Admin::IssueController < Admin::BaseController

  load_and_authorize_resource

  before_filter :fetch_issue, only: [:edit, :update, :destroy]
  before_filter :assign_search, only: [:index, :search]

  def index
    @issue = Issue.published_only.order("created_at DESC").page(params[:page]).per(20)
    @unpub_issue = Issue.unpublished_only.order("created_at Desc").
      page(params[:np_page]).per(20)
  end

  def search
    @issue = @q.result(distinct: true).order("number DESC").
                page(params[:page]).per(20)
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
  end

  def update
    if @issue.update_attributes(params[:issue])
      redirect_to(admin_issues_path, :notice => "The issue was successfully updated.")
    else
      render :action => "edit"
    end
  end

  def destroy
    @issue.destroy
    redirect_to(admin_issues_path)
  end

  private

  def assign_search
    @q = Issue.search(params[:q])
  end

  def fetch_issue
    @issue = Issue.find(params[:id])
  end
end

