class Api::CategoriesController < Api::BaseController
  def index
    api_response(categories)
  end

  def show
    api_response(category)
  end

  private

  def categories
    @categories ||= begin
      category_scope = Category.order(:name).select(:id, :name, :issued)
      category_scope = category_scope.issued(params[:issued].to_bool) if params[:issued].present?
      category_scope
    end
  end

  def category
    @category ||= Category.select(:id, :name, :issued).find(params[:id])
  end
end
