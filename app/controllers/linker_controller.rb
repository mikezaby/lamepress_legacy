class LinkerController < ApplicationController

  layout "base"

  def root
    @issue = Setting.current_issue
    @article = @article = Article.home(@issue.number.to_i)
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
    elsif @article = Article.home(params[:perma1].to_i)
      @issue = @article.first.issue
      render action: "Issue"
    else
      render_404
    end
  end

  def non_issued
    if !params[:perma2].nil?
      if (@article = Article.find_by_id(params[:perma2].split("-").first.to_i))
        @issue = Setting.current_issue
        render action: "Article"
      else
        render_404
      end
    elsif (@category = Category.where(permalink: params[:perma1], issued: false).first)
      @issue = Setting.current_issue
      @article = Article.where(category_id: @category.id)
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


end

