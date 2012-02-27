class Admin::BlockController < Admin::BaseController

  load_and_authorize_resource

  def index
    @block_top = Block.place('top')
    @block_left = Block.place('left')
    @block_right = Block.place('right')
    @block_bottom = Block.place('bottom')
  end

  def show
    @block = Block.find(params[:id])
  end

  def new
    @block = Block.new
  end

  def edit
    @block = Block.find(params[:id])
  end

  def create
    @block = Block.new(params[:block])

    if @block.save
      redirect_to(admin_blocks_path, :notice => 'Block was successfully created.')
    else
      render :action => "new"
    end
  end


  def update
    @block = Block.find(params[:id])

    if @block.update_attributes(params[:block])
      redirect_to(admin_blocks_path, :notice => 'Block was successfully updated.')
    else
      render :action => "edit"
    end
  end


  def destroy
    @block = Block.find(params[:id])
    @block.destroy
    redirect_to(admin_blocks_path)
  end

   def sorter
    blocks = Block.place(params['place'])
    blocks.each do |block|
      block.position = params['page'].index(block.id.to_s) + 1
      block.save
    end
    render :nothing => true
  end

end

