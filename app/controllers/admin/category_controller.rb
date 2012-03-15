class Admin::CategoryController < Admin::BaseController

  load_and_authorize_resource

  def index
    @category = Category.issued.page(params[:page]).per(20)
		@nonis_category = Category.non_issued.page(params[:ni_page]).per(20)
  end

  def new
  	@category=Category.new
		@linker=Linker.new
  end

  def create
  	@category = Category.new(params[:category])
    if @category.save
      redirect_to(admin_categories_path, :notice => 'Page was successfully created.')
    else
      render :action => "new"
    end
  end

  def edit
  	@category = Category.find(params[:id])
  end

  def update
  	@category = Category.find(params[:id])
    if @category.update_attributes(params[:category])
      redirect_to(admin_categories_path, :notice => 'Page was successfully updated.')
    else
      render :action => "edit"
    end
  end

  def destroy
  	@category = Category.find(params[:id])
    @category.destroy
    redirect_to(admin_categories_path)
  end

  def show
  	@category = Category.find_by_permalink(params[:permalink])
  end

end

