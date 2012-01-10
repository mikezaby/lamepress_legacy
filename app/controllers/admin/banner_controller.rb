class Admin::BannerController < Admin::BaseController

  load_and_authorize_resource

  def index
    @banner = Banner.all
  end

  def new
  	@banner=Banner.new
  end

  def create
		@banner = Banner.new(params[:banner])
    if @banner.save
      redirect_to(banners_path, :notice => 'Banner was successfully created.')
    else
      render :action => "new"
    end
  end

  def edit
  	@banner = Banner.find(params[:id])
  end

  def update
  	@banner = Banner.find(params[:id])
    if @banner.update_attributes(params[:banner])
      redirect_to(banners_path, :notice => 'Banner was successfully updated.')
    else
      render :action => "edit"
    end
  end

  def destroy
  	@banner = Banner.find(params[:id])
    @banner.destroy
    redirect_to(banners_path)
  end

  def show
  end


end

