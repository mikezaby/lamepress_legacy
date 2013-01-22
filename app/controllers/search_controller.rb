class SearchController < ApplicationController
  layout $layout

  def index
    @issue = Setting.current_issue
    @q = Article.search(params[:q], :auth_object => nil)
    @article = @q.result.page(params[:page]).order("date DESC").per(10)
    render action: :index
  end


  def issue
    issue = Issue.find_by_number(params[:issue][:number])
    if issue
      redirect_to "/issue/#{issue.number}"
    else
      redirect_to "/", :notice => "This issue does not exist"
    end
  end

end

