class Admin::IssueController < Admin::BaseController

  load_and_authorize_resource

  def index
    @issue = Issue.pub.page(params[:page]).per(20)
		@unpub_issue = Issue.unpub.page(params[:np_page]).per(20)

    respond_to do |format|
      format.html # index.html.erb
    end

  end

  def new
  	@issue=Issue.new
  	@act="create"
  	respond_to do |format|
      format.html # new.html.erb
    end
  end

  def create
		@issue = Issue.new(params[:issue])
    @issue.create_linker(:permalink=>"/"+@issue.number.to_s)
    respond_to do |format|
      if @issue.save
        format.html { redirect_to(issue_index_path, :notice => 'Page was successfully created.') }
      else
        format.html { render :action => "new" }
      end
    end
  end

  def edit
  	@issue = Issue.find(params[:id])
  	@act="update"
  end

  def update

  	@issue = Issue.find(params[:id])

    respond_to do |format|
      if @issue.update_attributes(params[:issue])
        format.html { redirect_to(issue_index_path, :notice => 'Page was successfully updated.'+params[:id]) }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  def destroy
  	@issue = Issue.find(params[:id])
		#@linker = Linker.find_by_permalink(@issue.number)
    #@linker.destroy
    @issue.destroy

    respond_to do |format|
      format.html { redirect_to(issue_index_path) }
    end
  end

  def show
  	@issue = Issue.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
    end
  end

  def reproc
    issue = Issue.find(:all)
    issue.each do |iss|
      iss.update_attributes(:cover => File.open("/home/miza/rails/mizatron/public/phpmedia/issue_"+iss.number.to_s+"/issue_"+iss.number.to_s+".jpg"), :pdf => File.open("/home/miza/rails/mizatron/public/phpmedia/issue_"+iss.number.to_s+"/issue_"+iss.number.to_s+".pdf"))
      #iss.update_attributes(:cover_file
    end
    render :text => "y0"
  end


end

