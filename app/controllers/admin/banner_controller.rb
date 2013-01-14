class Admin::BannerController < Admin::BaseController

  load_and_authorize_resource

  def index
    @banner_blocks = Block.where(mode: "banner")
    @banners = @banner_blocks.collect { |block| Banner.where(:block_id => block.id).order("position ASC")}
  end

  def new
    @banner=Banner.new
  end

  def create
    @banner = Banner.new(params[:banner])
    @banner.position = 99
    if @banner.save
      redirect_to(admin_banners_path, :notice => 'Banner was successfully created.')
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
      redirect_to(admin_banners_path, :notice => 'Banner was successfully updated.')
    else
      render :action => "edit"
    end
  end

  def destroy
    @banner = Banner.find(params[:id])
    @banner.destroy
    redirect_to(admin_banners_path)
  end

  def sorter
    Banner.where(block_id: params[:block_id]).each do |banner|
      banner.position = params['page'].index(banner.id.to_s) + 1
      banner.save
    end
    render :nothing => true
  end

end

