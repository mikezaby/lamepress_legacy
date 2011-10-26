class Admin::UserController < Admin::BaseController

  load_and_authorize_resource

  def index
		@user = User.all

    respond_to do |format|
      format.html # index.html.erb
    end

  end

  def new
  	@user=User.new
  	@act="create"
  	respond_to do |format|
      format.html # new.html.erb
    end
  end

  def create
  	@user = User.new(params[:user])

    respond_to do |format|
      if @user.save
        format.html { redirect_to(user_index_path, :notice => 'Page was successfully created.') }
      else
        format.html { render :action => "new" }
      end
    end
  end

  def edit
  	@user = User.find(params[:id])
  	@act="update"
  end

  def update
  	@user = User.find(params[:id])

    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to(@user, :notice => 'Page was successfully updated.') }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  def destroy
  	@user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to(user_index_path) }
    end
  end

  def show
  	 @user = User.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
    end
  end

end

