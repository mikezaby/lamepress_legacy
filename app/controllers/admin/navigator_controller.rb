class Admin::NavigatorController < Admin::BaseController

  load_and_authorize_resource

  def index
    @navigator = Navigator.orderit
  end

  def show
    @navigator = Navigator.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
    end
  end

  def new
    @navigator = Navigator.new
  end

  def edit
    @navigator = Navigator.find(params[:id])
  end

  def create
    @navigator = Navigator.new(params[:navigator])
    if @navigator.save
      redirect_to(navigators_path, :notice => 'Navigator was successfully created.')
    else
      render :action => "new"
    end
  end

  def update
    @navigator = Navigator.find(params[:id])

    if @navigator.update_attributes(params[:navigator])
      redirect_to(navigators_path, :notice => 'Navigator was successfully updated.')
    else
      render :action => "edit"
    end
  end

  def destroy
    @navigator = Navigator.find(params[:id])
    @navigator.destroy
    redirect_to(navigators_path)
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

