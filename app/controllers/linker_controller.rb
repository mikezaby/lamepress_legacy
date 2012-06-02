class LinkerController < ApplicationController

  layout $layout

  def root
    begin
      @issue = Setting.current_issue
      @issue = Issue.get_issue(Issue.maximum(:number)).first if @issue.nil? 
      @article = @article = Article.home(@issue.number.to_i)
      @url = "/issue_#{@issue.number}"
      render action: "#{$layout}/Issue"
    rescue
      render_404
    end
  end

  def issued
    @url = request.fullpath
    #article
    if !params[:perma3].nil?
      if (@article = Article.where(id: params[:perma3].split("-").first.to_i, published: true).joins(:issue).merge(Issue.pub).first)
        @issue = @article.issue
        render action: "#{$layout}/Article"
      else
        render_404
      end
    #issued category
    elsif !params[:perma2].nil?
      if (@category = Category.where(permalink: params[:perma2], issued: true).first) and (@issue = Issue.get_issue(params[:perma1].to_i).first)
        @article = Article.cat_home(params[:perma1], params[:perma2])
        if !@article.empty?
          render action: "#{$layout}/catshow"
        else
          @message = "No articles for this category in specific issue"
          render action: "#{$layout}/empty"
        end
      else
        render_404
      end
    #home issue
    elsif !(@issue = Issue.get_issue(params[:perma1]).first).nil?
      @article = Article.home(params[:perma1].to_i)
      render action: "#{$layout}/Issue"
    else
      render_404
    end
  end

  def non_issued
    @url = request.fullpath
    if !params[:perma2].nil?
      if (@article = Article.where(id: params[:perma2].split("-").first.to_i, published: true))
        @issue = Setting.current_issue
        render action: "#{$layout}/Article"
      else
        render_404
      end
    elsif (@category = Category.where(permalink: params[:perma1], issued: false).first)
      @issue = Setting.current_issue
      @article = Article.where(category_id: @category.id, published: true).order("date DESC").page(params[:page]).per(10)
      if !@article.empty?
        render action: "#{$layout}/Category"
      else
        @message = "No articles for this category"
        render action: "#{$layout}/empty"
      end
    else
      render_404
    end
  end

  def page
    if (@page =  Page.where(permalink: params[:perma]).published_only.first)
      @url = "/page/#{@page.permalink}"
      @issue = Setting.current_issue
      render action: "#{$layout}/page"
    else
      render_404
    end
  end

  def feed
    @posts = Article.where(category_id: params[:id], published: true).select("title, category_id, issue_id, author, id, html, created_at").order("created_at DESC").limit(20) 
    @category = @posts.first.category
    render :action => "feed.rss.builder", :layout => false
  end

end

