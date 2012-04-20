class SearchController < ApplicationController
  layout "base"

  def index
    @issue = Setting.current_issue
    @q = Article.search(params[:q])
    @article = @q.result(:distinct => true).page(params[:page]).per(20)
  end

end

