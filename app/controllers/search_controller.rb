class SearchController < ApplicationController
  layout "base"

  def index
    @issue = Setting.current_issue
    @q = Article.search(params[:q], :auth_object => nil)
    @article = @q.result.page(params[:page]).per(20)
  end

end

