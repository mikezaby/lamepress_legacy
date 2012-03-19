class LinkerController < ApplicationController

  layout "base"


  def forward
    #begin

  	  #expire_fragment('article_11513')
  	  if !params[:perma1].nil?
        @url= "/"+params[:perma1]
  		  @url += "/"+params[:perma2] unless params[:perma2].nil?
  		  @url += "/"+params[:perma3] unless params[:perma3].nil?
  	  else
  		  @current= CurrentIssue.find(:first)
        @url= "/"+@current.issue_number.to_s
  		  params[:perma1]=@current.issue_number
  	  end

		  if @linker = Linker.find_by_permalink(@url)
        type=@linker.linkerable_type
        id=@linker.linkerable_id
        if @linker.linkerable_type=="Issue"
            #todo na min fenode unpublished
			      @iss=@linker.linkerable.number
			      @issue=@linker.linkerable
        elsif @linker.linkerable_type=="Article"

          @article= @linker.linkerable

          if @article.issue_id.nil?
  		      @current= CurrentIssue.find(:first)
  			    @issue= @current.issue
  			    @iss=@issue.number
  		    else
  		      @iss=@linker.linkerable.issue_number
  		      @issue=@linker.linkerable.issue
  		    end

  		  elsif @linker.linkerable_type=="Category"

  		    @current= CurrentIssue.find(:first)
  			  @issue= @current.issue
  			  @iss =@issue.number
  		    @article = @linker.linkerable.articles.order("date DESC").page(params[:page]).per(10)

  		  end
		    render :action => @linker.linkerable_type
        #render :action => "test"

		  elsif (!(@article = Article.cat_home(params[:perma1], params[:perma2])).empty?)
		    type="home category"
			  @issue= @article[0].issue
			  id=@issue.id
			  @iss =@issue.number
			  render :action => "catshow"
  	  else
  	    type="current issue"
  		  @current= CurrentIssue.find(:first)
			  @issue= @current.issue
			  @iss =@issue.number
  		  @mnom = "Den iparxeis"
  		  render :action => "mnom"
  	  end
#    rescue Exception => link
#      render :text => "controller=>linker </br> type => #{type}</br> id=> #{id}</br> error =>#{link.message}"
#    end


  end

  def destroy
  	@linker = Linker.find(params[:id])
    @linker.destroy
    respond_to do |format|
      format.html { redirect_to(article_index_path) }
    end
  end



end

