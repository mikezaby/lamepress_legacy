class Admin::ArticleController < Admin::BaseController

  load_and_authorize_resource

  ActionController::Base.prepend_view_path("app/themes/#{$layout}")

  before_filter :assign_search, only: [:index, :search]
  before_filter :fetch_article, only: [:edit, :update, :destroy, :show]

  def index
    @article = Article.issued.page(params[:page]).order("date DESC").per(20)
    @nonis_article = Article.non_issued.page(params[:ni_page]).
                             order("date DESC").per(20)
  end

  def new
    @article=Article.new
  end

  def search
    @article = @q.result(distinct: true).order("date DESC").
                  page(params[:page]).per(20)
  end

  def create
    @article = Article.new(params[:article])
    @article.build_ordering
    @article.ordering.cat_pos=99
    if @article.preview == "1" && @article.valid?
      show
    elsif @article.save
      redirect_to(admin_articles_path, :notice => 'Page was successfully created.')
    else
      render :action => "new"
    end
  end

  def edit
  end

  def update
    if params[:article][:preview] == "1" && @article.valid?
      show
    elsif @article.update_attributes(params[:article])
      redirect_to(admin_articles_path, :notice => 'Page was successfully updated.')
    else
      render :action => "edit"
    end
  end

  def destroy
    @article.destroy
    redirect_to(admin_articles_path)
  end

  def show
    @issue = @article.issue ||  Setting.current_issue || Issue.first
    render "/article/issued_article", layout: $layout
  end

  private

  def assign_search
    @q = Article.search(params[:q], auth_object: 'admin')
  end

  def fetch_article
    @article = @article = Article.find(params[:id])
  end
end
