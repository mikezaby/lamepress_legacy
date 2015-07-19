class Admin::CategoryController < Admin::BaseController

  load_and_authorize_resource

  before_filter :fetch_category, only: [:edit, :update, :destroy]

  def index
    @category = Category.issued.page(params[:page]).per(20)
    @nonis_category = Category.non_issued.page(params[:ni_page]).per(20)
  end

  def new
    @category=Category.new
  end

  def create
    @category = Category.new(category_params)
    if @category.save
      redirect_to(admin_categories_path, :notice => 'Page was successfully created.')
    else
      render :action => "new"
    end
  end

  def edit
  end

  def update
    if @category.update_attributes(category_params)
      redirect_to(admin_categories_path, :notice => 'Page was successfully updated.')
    else
      render :action => "edit"
    end
  end

  def destroy
    @category.destroy
    redirect_to(admin_categories_path)
  end

  private

  def fetch_category
    @category = Category.find(params[:id])
  end

  def category_params
    params.require(:category).permit!
  end
end

