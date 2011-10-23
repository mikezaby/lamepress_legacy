class Admin::BlockController < Admin::BaseController
  # GET /navigators.xml
  def index
    @block_top = Block.place('top')
    @block_left = Block.place('left')
    @block_right = Block.place('right')
    @block_bottom = Block.place('bottom')

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # GET /navigators/1
  # GET /navigators/1.xml
  def show
    @block = Block.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
    end
  end

  # GET /navigators/new
  # GET /navigators/new.xml
  def new
    @block = Block.new
    @act="create"
    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # GET /navigators/1/edit
  def edit
    @block = Block.find(params[:id])
    @act="update"
  	respond_to do |format|
      format.html # new.html.erb
    end
  end

  # POST /navigators
  # POST /navigators.xml
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

  # PUT /navigators/1
  # PUT /navigators/1.xml
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

  # DELETE /navigators/1
  # DELETE /navigators/1.xml
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
	#delete_cache
    render :nothing => true
     #logger.info 'informational message'
  end

end

