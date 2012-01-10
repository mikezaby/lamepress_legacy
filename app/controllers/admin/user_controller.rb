class Admin::UserController < Admin::BaseController

  load_and_authorize_resource

  def index
		@user = User.all
  end

  def new
  	@user=User.new
  end

  def create
  	@user = User.new(params[:user])

    if @user.save
      redirect_to(users_path, :notice => 'User was successfully created.')
    else
      render :action => "new"
    end
  end

  def edit
  	@user = User.find(params[:id])
  end

  def roles
  	@user = User.find(params[:id])
  end

  def update
  	@user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      redirect_to(users_path, :notice => 'User was successfully updated.')
    else
      render :action => "edit"
    end
  end

  def destroy
  	@user = User.find(params[:id])
    @user.destroy
    redirect_to(users_path)
  end

  def show
  	 @user = User.find(params[:id])
  end

end

