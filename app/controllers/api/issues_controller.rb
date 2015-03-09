class Api::IssuesController < Api::BaseController
  def index
    api_response(issues)
  end

  private

  def issues
    @issues ||= begin
      issue_scope = Issue.order(:number).select(:id, :number, :date, :published)
      issue_scope.search_issues(params[:year], params[:month])
    end
  end
end
