class Admin::BannerController < Admin::BaseController
  load_and_authorize_resource

  before_action :fetch_banner, only: [:edit, :update, :destroy]
  before_action :fetch_banner_blocks, only: [:new, :create, :edit, :update]

  def index
    @group_banners = Banner.order([:block_id, :position]).includes(:block).
                            group_by { |banner| banner.block.name  }
  end

  def new
    @banner=Banner.new
  end

  def create
    @banner = Banner.new(banner_params)
    @banner.position = 99
    if @banner.save
      redirect_to(admin_banners_path, :notice => 'Banner was successfully created.')
    else
      render :action => "new"
    end
  end

  def edit
  end

  def update
    if @banner.update_attributes(banner_params)
      redirect_to(admin_banners_path, :notice => 'Banner was successfully updated.')
    else
      render :action => "edit"
    end
  end

  def destroy
    @banner.destroy
    redirect_to(admin_banners_path)
  end

  def sorter
    Banner.includes(:block).where(block_id: params[:block_id]).each do |banner|
      banner.position = params['position'].index(banner.id.to_s) + 1
      banner.save!
    end

    render json: { notice: 'Banners was successfully sorted' }
  end

  private

  def fetch_banner
    @banner = Banner.find(params[:id])
  end

  def fetch_banner_blocks
    @banner_blocks = Block.where(mode: "banner").pluck(:name, :id)
  end

  def banner_params
    params.require(:banner).permit!
  end
end

