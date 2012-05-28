class Admin::OrderingController < Admin::BaseController
  
  load_and_authorize_resource

  cache_sweeper :ordering_sweeper

  def index
  end

  def priority
    if params[:issue_id].present? and params[:category_id].present?
      @articles = Article.joins(:ordering).where(issue_id: params[:issue_id], category_id: params[:category_id]).order("cat_pos ASC")
      @articles.first.nil? ? (redirect_to admin_orderings_path, :notice => "No articles in this category") : (render "category")
    elsif params[:issue_id].present?
      articles = Article.joins(:ordering).where(issue_id: params[:issue_id])
      @issue = articles.first.issue
      @not_ordered = articles.merge(Ordering.where(issue_pos: nil)).collect {|article| article.ordering}
      @ordered = articles.merge(Ordering.where("issue_pos is not null").order("issue_pos ASC"))
      render "issue"
    else
      redirect_to admin_orderings_path, :notice => "Wrong values"
    end
  end

  def category
    
  end

  def update_issue
    orderings = Ordering.find(params[:ordering][:id])
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

end
