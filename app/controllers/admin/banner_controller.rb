class Admin::BannerController < Admin::BaseController

   def index

    @banner = Banner.all

    respond_to do |format|
      format.html # index.html.erb
    end

  end

  def new
  	@banner=Banner.new
  	@act="create"
  	respond_to do |format|
      format.html # new.html.erb
    end
  end

  def create
		@banner = Banner.new(params[:banner])
    respond_to do |format|
      if @banner.save
        format.html { redirect_to(banner_index_path, :notice => 'Banner was successfully created.') }
      else
        format.html { render :action => "new" }
      end
    end
  end

  def edit
  	@banner = Banner.find(params[:id])
  	@act="update"
  end

  def update

  	@banner = Banner.find(params[:id])

    respond_to do |format|
      if @banner.update_attributes(params[:banner])
        format.html { redirect_to(banner_index_path, :notice => 'Banner was successfully updated.') }

      else
        format.html { render :action => "edit" }
      end
    end
  end

  def destroy
  	@banner = Banner.find(params[:id])
    @banner.destroy
    respond_to do |format|
      format.html { redirect_to(banner_index_path) }
    end
  end

  def show

  end


end

