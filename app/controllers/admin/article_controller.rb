class Admin::ArticleController < Admin::BaseController

  load_and_authorize_resource

  cache_sweeper :article_sweeper

  def index
    @q = Article.search(params[:q]) 
  	@article = Article.issued.page(params[:page]).per(20)
		@nonis_article = Article.non_issued.page(params[:ni_page]).per(20)
  end

  def new
  	@article=Article.new
  end

  def search
    @q = Article.search(params[:q])
    @article = @q.result(:distinct => true).page(params[:page]).per(20)
  end

  def create
		@article = Article.new(params[:article])
    if @article.preview == "1"
      @issue = (@article.issue_id.nil? ? Setting.current_issue : Issue.find_by_id(@article.issue_id))
      render :action => "preview", :layout => "base"
    elsif @article.save
      @article.create_ordering(:cat_pos => 99 ) unless @article.issue_id.nil?
      redirect_to(admin_articles_path, :notice => 'Page was successfully created.')
    else
      render :action => "new"
    end
  end

  def edit
  	@article = Article.find(params[:id])
  end

  def update
  	@article = Article.find(params[:id])
    if params[:article][:preview] == "1"
      @issue = (@article.issue_id.nil? ? Setting.current_issue : Issue.find_by_id(@article.issue_id))
      render :action => "preview", :layout => "base"
    elsif @article.update_attributes(params[:article])
      redirect_to(admin_articles_path, :notice => 'Page was successfully updated.')
    else
      render :action => "edit"
    end
  end

  def destroy
  	@article = Article.find(params[:id])
    @article.destroy
    redirect_to(admin_articles_path)
  end

  def show
  	@article = Article.find_by_id(params[:id])
    @issue = (@article.issue_id.nil? ? Setting.current_issue : Issue.find_by_id(@article.issue_id))
    render :action => "preview"
  end


  # def reproc
  #   article = Article.where("photo_file_name IS NOT NULL")
  #   article.each do |art|
  #     begin
  #       if !art.issue_id.nil?
  #         art.update_attributes(:photo => File.open("/home/miza/rails/mizatron/public/phpmedia/issue_"+art.issue_number.to_s+"/"+art.photo_file_name))
  #       else
  #         art.update_attributes(:photo => File.open("/home/miza/rails/mizatron/public/phpmedia/cat_"+art.category_id.to_s+"/"+art.photo_file_name))
  #       end
  #     rescue Exception => link
  #       puts "#id=> #{art.id}, error =>#{link.message}"
  #     end
  #   end
  #   render :text => "y0"
  # end

end

