class Admin::NavigatorController < Admin::BaseController
  load_and_authorize_resource

  before_filter :fetch_navigator, only: [:edit, :update, :destroy]
  before_action :fetch_navigator_blocks, only: [:new, :create, :edit, :update]

  def index
    @navigator_blocks = Block.where(mode: "navigator")
    @group_navigators = Navigator.includes(:block).order([:block_id, :position]).
                                  group_by { |navigator| navigator.block.name }
  end

  def new
    @navigator = Navigator.new
  end

  def edit
  end

  def create
    @navigator = Navigator.new(navigator_params)
    if @navigator.save
      redirect_to(admin_navigators_path, :notice => 'Navigator was successfully created.')
    else
      render :action => "new"
    end
  end

  def update
    if @navigator.update_attributes(navigator_params)
      redirect_to(admin_navigators_path, :notice => 'Navigator was successfully updated.')
    else
      render :action => "edit"
    end
  end

  def destroy
    @navigator.destroy
    redirect_to(admin_navigators_path)
  end

  def sorter
    Navigator.where(block_id: params['block_id']).each do |navigator|
      navigator.position = params['position'].index(navigator.id.to_s) + 1
      navigator.save
    end

    render json: { notice: 'Navigators was successfully sorted' }
  end

  private

  def fetch_navigator
    @navigator = Navigator.find(params[:id])
  end

  def navigator_params
    params.require(:navigator).permit!
  end

  def fetch_navigator_blocks
    @navigator_blocks = Block.where(mode: "navigator").pluck(:name, :id)
  end
end
