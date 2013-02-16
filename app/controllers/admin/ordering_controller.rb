class Admin::OrderingController < Admin::BaseController

  load_and_authorize_resource

  before_filter :fetch_issues, only: [:index, :priority]

  def index
  end

  def priority
    if params[:issue_id].present?
      @issue = Issue.find(params[:issue_id])
    elsif params[:issue_number].present?
      @issue = Issue.find_by_number!(params[:issue_number])
    end

    if @issue and params[:category_id].present?
      @articles = @issue.articles.joins(:ordering).
                         where( category_id: params[:category_id]).
                         order("cat_pos ASC")
      if @articles.empty?
        flash[:notice] = "No articles in this category"
        render 'index'
      else
        render "category"
      end
    elsif @issue
      articles = @issue.articles.joins(:ordering)
      @not_ordered = articles.merge(Ordering.where(issue_pos: nil)).collect {|article| article.ordering}
      @ordered = articles.merge(Ordering.where("issue_pos is not null").order("issue_pos ASC"))
      render "issue"
    else
      flash[:notice] = "wrong values"
      redirect_to admin_orderings_path
    end
  end

  def update_issue
    orderings = Ordering.where(id: params[:ordering][:id])
    orderings.each do |ordering|
      ordering.issue_pos=99
      ordering.save
    end
    flash[:notice] = 'Ordering updated'
    redirect_to :back
  end

  def destroy
    ordering = Ordering.find(params[:id])
    ordering.issue_pos = nil
    ordering.save
    redirect_to :back
  end

  def sorter
    Ordering.find(params['page']).each do |ordering|
      if params['what'] == "issue"
        ordering.issue_pos = params['page'].index(ordering.id.to_s) + 1
      elsif params['what'] == "category"
        ordering.cat_pos = params['page'].index(ordering.id.to_s) + 1
      end
      ordering.save
    end
    render :nothing => true
  end

  private

  def fetch_issues
    @search_issues = Issue.order("created_at desc").limit(5)
  end
end
