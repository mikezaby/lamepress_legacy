class LinkerController < ApplicationController

  layout $layout

  def root
    @issue = Setting.current_issue
    @article = @article = Article.home(@issue.number.to_i)
    @url = "/issue_#{@issue.number}"
    render action: "Issue"
  end

  def issued
    @url = request.fullpath
    #article
    if !params[:perma3].nil?
      if (@article = Article.find_by_id(params[:perma3].split("-").first.to_i))
        @issue = @article.issue
        render action: "Article"
      else
        render_404
      end
    #issued category
    elsif !params[:perma2].nil?
      if (@category = Category.where(permalink: params[:perma2], issued: true).first) and (@issue = Issue.find_by_number(params[:perma1].to_i))
        @article = Article.cat_home(params[:perma1], params[:perma2])
        if !@article.empty?
          render action: "catshow"
        else
          @message = "No articles for this category in specific issue"
          render action: "empty"
        end
      else
        render_404
      end
    #home issue
    elsif !(@article = Article.home(params[:perma1].to_i)).empty?
      @issue = @article.first.issue
      render action: "Issue"
    else
      render_404
    end
  end

  def non_issued
    @url = request.fullpath
    if !params[:perma2].nil?
      if (@article = Article.find_by_id(params[:perma2].split("-").first.to_i))
        @issue = Setting.current_issue
        render action: "Article"
      else
        render_404
      end
    elsif (@category = Category.where(permalink: params[:perma1], issued: false).first)
      @issue = Setting.current_issue
      @article = Article.where(category_id: @category.id).order("date DESC").page(params[:page]).per(10)
      if !@article.empty?
        render action: "Category"
      else
        @message = "No articles for this category"
        render action: "empty"
      end
    else
      render_404
    end
  end

  def page
    if (@page =  Page.where(permalink: params[:perma]).published_only.first)
      @url = "/page/#{@page.permalink}"
      @issue = Setting.current_issue
    else
      render_404
    end
  end

  def php
    if !params[:article_id].nil?
      if (@article = Article.find_by_id(params[:article_id].to_i))
        url1 = @article.issue_id.present? ? "/issue_#{@article.issue_number}" : ""
        @url = "#{url1}/#{@article.category_name}/#{@article.id}-#{@article.prettify_permalink}"
        redirect_to @url
      else
        render_404
      end
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

