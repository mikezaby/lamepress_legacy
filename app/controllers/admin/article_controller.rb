class Admin::ArticleController < Admin::BaseController

  load_and_authorize_resource

  cache_sweeper :article_sweeper

  def index
  	@article = Article.issued.page(params[:page]).per(20)
		@nonis_article = Article.non_issued.page(params[:ni_page]).per(20)
    respond_to do |format|
      format.html # index.html.erb
    end

  end

  def new
  	@article=Article.new
  	@act="create"
  	respond_to do |format|
      format.html # new.html.erb
    end
  end

  def create
		@article = Article.new(params[:article])
		url=""
		url= "/"+@article.issue_number.to_s unless @article.issue_id.nil?
		url+="/"+@article.category_permalink+"/"+@article.title.parameterize unless @article.category_id.nil?
    respond_to do |format|
      if @article.save
        @article.create_ordering(:cat_pos => 99 ) unless @article.issue_id.nil?
        if @article.create_linker(:permalink => url)
          format.html { redirect_to(article_index_path, :notice => 'Page was successfully created.') }
        else
          format.html { render :action => "new" }
        end
      else
        format.html { render :action => "new" }
      end
    end
  end

  def edit
  	@article = Article.find(params[:id])
  	@act="update"
  end

    def update
  	@article = Article.find(params[:id])

    respond_to do |format|
      if @article.update_attributes(params[:article])
        format.html { redirect_to(article_index_path, :notice => 'Page was successfully updated.') }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  def destroy
  	@article = Article.find(params[:id])
    @article.destroy
    respond_to do |format|
      format.html { redirect_to(article_index_path) }
    end
  end

  def show

  	@article = Article.find_by_id(params[:id])

    respond_to do |format|
      format.html # show.html.erb
    end
  end

  def reproc
    article = Article.where("photo_file_name IS NOT NULL")
    article.each do |art|
      begin
        if !art.issue_id.nil?
          art.update_attributes(:photo => File.open("/home/miza/rails/mizatron/public/phpmedia/issue_"+art.issue_number.to_s+"/"+art.photo_file_name))
        else
          art.update_attributes(:photo => File.open("/home/miza/rails/mizatron/public/phpmedia/cat_"+art.category_id.to_s+"/"+art.photo_file_name))
        end
      rescue Exception => link
        puts "#id=> #{art.id}, error =>#{link.message}"
      end
    end
    render :text => "y0"
  end

end

