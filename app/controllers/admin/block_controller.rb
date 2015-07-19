class Admin::BlockController < Admin::BaseController
  load_and_authorize_resource

  before_action :fetch_block, only: [:edit, :update, :destroy]

  def index
    @block_placements = Setting.block_placements
    @group_blocks = Block.order([:placement, :position]).group_by(&:placement)
  end

  def new
    @block = Block.new
    @block_placements = Setting.block_placements
  end

  def edit
    @block_placements = Setting.block_placements
  end

  def create
    @block = Block.new(block_params)
    @block.position = 99
    if @block.save
      redirect_to(admin_blocks_path, :notice => 'Block was successfully created.')
    else
      render :action => "new"
    end
  end


  def update
    if @block.update_attributes(block_params)
      redirect_to(admin_blocks_path, :notice => 'Block was successfully updated.')
    else
      render :action => "edit"
    end
  end


  def destroy
    @block.destroy
    redirect_to(admin_blocks_path)
  end

  def sorter
    Block.place(params['place']).each do |block|
      block.position = params['position'].index(block.id.to_s) + 1
      block.save!
    end

    render json: { notice: 'Blocks was successfully sorted' }
  end

  private

  def fetch_block
    @block = Block.find(params[:id])
  end

  def block_params
    params.require(:block).permit!
  end
end
