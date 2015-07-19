class Admin::UserController < Admin::BaseController
  load_and_authorize_resource

  before_action :fetch_user, only: [:edit, :update, :destroy, :roles]

  def index
    @user = User.all
  end

  def new
    @user=User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      redirect_to(admin_users_path, :notice => 'User was successfully created.')
    else
      render :action => "new"
    end
  end

  def edit
  end

  def roles
  end

  def update
    if @user.update_attributes(user_params)
      redirect_to(admin_users_path, :notice => 'User was successfully updated.')
    else
      render :action => "edit"
    end
  end

  def destroy
    @user.destroy
    redirect_to(admin_users_path)
  end

  private

  def fetch_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit!
  end
end

