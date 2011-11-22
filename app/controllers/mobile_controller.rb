class MobileController < ApplicationController

  def menu
    categories = Category.mobile_issued
    render :json => categories
  end

  def category
    articles = Article.where("issue_id = ? AND category_id= ? AND published = TRUE",params[:issue], params[:category]).select("id,title,html")
    render :json => articles
  end

  def article
    article = Article.where("id = ? AND published = TRUE",params[:article]).select("id,title,html")
    render :json => article.first
  end

end

