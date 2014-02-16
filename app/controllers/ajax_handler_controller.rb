class AjaxHandlerController < ApplicationController

  def search_issues
    issues_links = fetch_issues do |issue|
      view_context.link_to issue.number, home_issue_path(issue.number)
    end

    render text: issues_links.join
  end

  def admin_search_issues
    issues_links = fetch_issues(published: false) do |issue|
      view_context.link_to issue.number, priority_admin_orderings_path(issue_id: issue.id),
                           class: 'issue_link'
    end

    render text: issues_links.join
  end

  private

  def fetch_issues(options = {})
    published = options.fetch(:published) { true }
    year = params.fetch(:year) { Date.today.year.to_s }
    month = params.fetch(:month) { Date.today.month.to_s }.rjust(2, '0')

    Issue.search_issues(year, month, published).map { |issue| yield(issue) }
  end
end
