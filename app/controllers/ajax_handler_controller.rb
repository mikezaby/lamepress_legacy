class AjaxHandlerController < ApplicationController

  def search_issues
    issues=""
    year=params[:year]
    month=params[:month]
    month="0"+month.to_s if month.to_i < 10
    search_issues = Issue.search_issues(year,month,true)
    search_issues.each do |search_issue|
      issues += '<a href="/issue/'+search_issue.number.to_s+'">'+search_issue.number.to_s+'</a>'
    end
    render :text => issues
  end

  def admin_search_issues
    issues=""
    year=params[:year]
    month=params[:month]
    month="0"+month.to_s if month.to_i < 10
    search_issues = Issue.search_issues(year,month,false)
    search_issues.each do |search_issue|
      issues += '<a class="issue_link" href="/admin/ordering/priority?issue_id='+search_issue.id.to_s+'">'+search_issue.number.to_s+'</a>'
    end
    render :text => issues
  end

end
