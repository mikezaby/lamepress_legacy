class Admin::BlockController < Admin::BaseController

  load_and_authorize_resource

  def index
    @block_top = Block.place('top')
    @block_left = Block.place('left')
    @block_right = Block.place('right')
    @block_bottom = Block.place('bottom')

    respond_to do |format|
      format.html # index.html.erb
    end
  end


  def show
    @block = Block.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
    end
  end


  def new
    @block = Block.new
    @act="create"
    respond_to do |format|
      format.html # new.html.erb
    end
  end

  def edit
    @block = Block.find(params[:id])
    @act="update"
  	respond_to do |format|
      format.html # new.html.erb
    end
  end


  def create
    @block = Block.new(params[:block])

    respond_to do |format|
      if @block.save
        format.html { redirect_to(block_index_path, :notice => 'Block was successfully created.') }
      else
        format.html { render :action => "new" }
      end
    end
  end


  def update
    @block = Block.find(params[:id])

    respond_to do |format|
      if @block.update_attributes(params[:block])
        format.html {  redirect_to(block_index_path, :notice => 'Block was successfully updated.') }
      else
        format.html { render :action => "edit" }
      end
    end
  end


  def destroy
    @block = Block.find(params[:id])
    @block.destroy

    respond_to do |format|
      format.html { redirect_to(block_index_path) }
    end
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

