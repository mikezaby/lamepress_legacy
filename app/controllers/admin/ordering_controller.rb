class Admin::OrderingController < Admin::BaseController

  load_and_authorize_resource

  before_filter :fetch_issues, only: [:index, :priority]
  before_filter :fetch_years, only: [:index, :priority]

  def index
  end

  def priority
    @issue = Issue.find_by(id: params[:issue_id])
    @category = Category.find_by(id: params[:category_id]) if params[:category_id].present?

    if @issue and @category
      @orderings = Ordering.includes(:article).for_issue(@issue).
                          for_category(@category).
                          order(:cat_pos).pluck('articles.title', :id)
      if @orderings.empty?
        flash[:notice] = "No articles in this category"
        render 'index'
      else
        render "category"
      end
    elsif @issue
      @not_ordered = Ordering.includes(:article).for_issue(@issue).
                              without_issue_position.pluck('articles.title', :id)
      @ordered = Ordering.includes(:article).for_issue(@issue).with_issue_position.
                          order(:issue_pos).pluck('articles.title', :id)
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
    Ordering.find(params['position']).each do |ordering|
      if params['what'] == "issue"
        ordering.issue_pos = params['position'].index(ordering.id.to_s) + 1
      elsif params['what'] == "category"
        ordering.cat_pos = params['position'].index(ordering.id.to_s) + 1
      end
      ordering.save
    end
    render :nothing => true
  end

  private

  def fetch_issues
    @search_issues = Issue.order("created_at desc").limit(5)
  end

  def fetch_years
    @years = Issue.uniq.order(:date).pluck("YEAR(date)")
  end
end
