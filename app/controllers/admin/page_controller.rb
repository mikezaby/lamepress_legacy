class Admin::PageController < Admin::BaseController
  
  load_and_authorize_resource

  cache_sweeper :page_sweeper

  def index
    @pages = Page.all
  end

  def new
    @page = Page.new
  end

  def create
    @page = Page.new(params[:page])
    if params[:page][:preview] == "1"
      @issue = Setting.current_issue
      render :action => "show", :layout => "base"
    elsif @page.save
      redirect_to new_admin_page_url, notice: 'Page was successfully created.'
    else
      render action: "new"
    end
  end

  def edit
    @page = Page.find(params[:id])
  end

  def update
    @page = Page.find(params[:id])
    if params[:page][:preview] == "1"
      @issue = Setting.current_issue
      @page = Page.new(params[:page])
      render :action => "show", :layout => "base"
    elsif @page.update_attributes(params[:page])
      redirect_to admin_pages_url, notice: 'Page was successfully updated.'
    else
      render action: "edit" 
    end
  end

  def show
    @issue = Setting.current_issue
    @page = Page.find(params[:id])
    render :action => "show", :layout => "base"
  end

  def destroy
    @page = Page.find(params[:id])
    @page.destroy
    redirect_to admin_pages_url, notice: "Page was successfully deleted."
  end

end
