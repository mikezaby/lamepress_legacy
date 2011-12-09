class SearchController < ApplicationController
  layout "base"

  def index
    @current= CurrentIssue.find(:first)
    @issue = @current.issue
    @article = Article.search(params[:search])
  end

end

