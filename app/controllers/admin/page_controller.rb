class Admin::PageController < Admin::BaseController
  load_and_authorize_resource
  before_action :fetch_page, only: [:edit, :update, :show, :destroy]

  def index
    @pages = Page.all
  end

  def new
    @page = Page.new
  end

  def create
    @page = Page.new(page_params)
    if page_params[:preview] == "1"
      @issue = Setting.current_issue
      render :action => "show", :layout => $layout
    elsif @page.save
      redirect_to new_admin_page_url, notice: 'Page was successfully created.'
    else
      render action: "new"
    end
  end

  def edit
  end

  def update
    if page_params[:preview] == "1"
      @issue = Setting.current_issue
      @page = Page.new(page_params)
      render :action => "show", :layout => $layout
    elsif @page.update_attributes(page_params)
      redirect_to admin_pages_url, notice: 'Page was successfully updated.'
    else
      render action: "edit"
    end
  end

  def show
    @issue = Setting.current_issue
    render :action => "show", :layout => $layout
  end

  def destroy
    @page.destroy
    redirect_to admin_pages_url, notice: "Page was successfully deleted."
  end

  private

  def page_params
    params.require(:page).permit!
  end

  def fetch_page
    @page = Page.find(params[:id])
  end
end
