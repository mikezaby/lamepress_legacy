class Admin::CategoryController < Admin::BaseController

   def index
    @category = Category.issued.page(params[:page]).per(20)
		@nonis_category = Category.non_issued.page(params[:ni_page]).per(20)

    respond_to do |format|
      format.html # index.html.erb
    end

  end

  def new
  	@category=Category.new
		@linker=Linker.new
  	@act="create"
  	respond_to do |format|
      format.html # new.html.erb
    end
  end

  def create
  	@category = Category.new(params[:category])
  	@category.permalink=@category.name.parameterize
		if !@category.issued
			@category.create_linker(:permalink => "/"+@category.permalink)
		end
    respond_to do |format|
      if @category.save
    		format.html { redirect_to(category_index_path, :notice => 'Page was successfully created.') }
    	else
      	format.html { render :action => "new" }
      end
    end
  end

  def edit
  	@category = Category.find(params[:id])
  	@act="update"
  	respond_to do |format|
      format.html # new.html.erb
    end
  end

  def update
  	@category = Category.find(params[:id])
    @category.permalink=params[:category][:name].parameterize
    respond_to do |format|
      if @category.update_attributes(params[:category])
        format.html { redirect_to(category_index_path, :notice => 'Page was successfully updated.') }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  def destroy
  	@category = Category.find(params[:id])
    @category.destroy

    respond_to do |format|
      format.html { redirect_to(category_index_path) }
    end
  end

  def show
  	@category = Category.find_by_permalink(params[:permalink])

    respond_to do |format|
      format.html # show.html.erb
    end
  end

end

