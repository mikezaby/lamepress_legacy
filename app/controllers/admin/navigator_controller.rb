class Admin::NavigatorController < Admin::BaseController

  load_and_authorize_resource

  # GET /navigators.xml
  def index
    @navigator = Navigator.orderit
    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # GET /navigators/1
  # GET /navigators/1.xml
  def show
    @navigator = Navigator.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
    end
  end

  # GET /navigators/new
  # GET /navigators/new.xml
  def new
    @navigator = Navigator.new
    @act="create"
    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # GET /navigators/1/edit
  def edit
    @navigator = Navigator.find(params[:id])
    @act="update"
  	respond_to do |format|
      format.html # new.html.erb
    end
  end

  def create
    @navigator = Navigator.new(params[:navigator])

    respond_to do |format|
      if @navigator.save
        format.html { redirect_to(navigator_index_path, :notice => 'Navigator was successfully created.') }
      else
        format.html { render :action => "new" }
      end
    end
  end

  # PUT /navigators/1
  # PUT /navigators/1.xml
  def update
    @navigator = Navigator.find(params[:id])

    respond_to do |format|
      if @navigator.update_attributes(params[:navigator])
        format.html { redirect_to(navigator_index_path, :notice => 'Navigator was successfully updated.') }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  # DELETE /navigators/1
  # DELETE /navigators/1.xml
  def destroy
    @navigator = Navigator.find(params[:id])
    @navigator.destroy

    respond_to do |format|
      format.html { redirect_to(navigator_index_path) }
    end
  end

  def sorter
    navigators = Navigator.where("block_id =?",params['block_id'])
    navigators.each do |navigator|
      navigator.position = params['page'].index(navigator.id.to_s) + 1
      navigator.save
    end
	#delete_cache
    render :nothing => true
     #logger.info 'informational message'
  end


end

