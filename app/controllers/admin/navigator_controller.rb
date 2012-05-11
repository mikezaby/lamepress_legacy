class Admin::NavigatorController < Admin::BaseController

  load_and_authorize_resource

  def index
    @navigator_blocks = Block.get_mode("navigator")
    @navigators = @navigator_blocks.map(&:id).collect {|block_id| Navigator.list(block_id)}
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
      redirect_to(admin_navigators_path, :notice => 'Navigator was successfully created.')
    else
      render :action => "new"
    end
  end

  def update
    @navigator = Navigator.find(params[:id])

    if @navigator.update_attributes(params[:navigator])
      redirect_to(admin_navigators_path, :notice => 'Navigator was successfully updated.')
    else
      render :action => "edit"
    end
  end

  def destroy
    @navigator = Navigator.find(params[:id])
    @navigator.destroy
    redirect_to(admin_navigators_path)
  end

  def sorter
    Navigator.where(block_id: params['block_id']).each do |navigator|
      navigator.position = params['page'].index(navigator.id.to_s) + 1
      navigator.save
    end
	#delete_cache
    render :nothing => true
  end


end

