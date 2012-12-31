require 'spec_helper'
include ArticleHelper

describe ArticleController do
  let(:issue) { FactoryGirl.create(:issue, :public) }
  let(:unpublished_issue) { FactoryGirl.create(:issue) }

  let(:category) { FactoryGirl.create(:category) }
  let(:issued_category) { FactoryGirl.create(:issued_category) }

  let(:issued_article) { FactoryGirl.create(:issued_article, issue: issue) }
  let(:unpublished_issued_article) { FactoryGirl.create(:issued_article,
                                                        :unpublished, issue: issue,
                                                        category: issued_category) }
  let(:home_articles) { FactoryGirl.create_list(:home_article, 3, issue: issue) }
  let(:unpublished_home_article) { FactoryGirl.create(:home_article,
                                                      :unpublished, issue: issue) }
  let(:sorted_home_articles) do
    home_articles.sort { |a, b| a.ordering.issue_pos <=> b.ordering.issue_pos }
  end
  let(:issued_category_articles) { FactoryGirl.create_list(:article, 3,
                                                           :category_ordered,
                                                           category: issued_category,
                                                           issue: issue) }

  let(:category_articles) { FactoryGirl.create_list(:article, 3,
                                                     category: category) }
  let(:category_article) { FactoryGirl.create(:article, category: category) }
  let(:unpublished_category_article) { FactoryGirl.create(:article, :unpublished,
                                                           category: category) }

  describe "GET home_issue" do
    it "renders template home_issue" do
      get :home_issue, number: issue.number

      response.should render_template(:home_issue)
    end

    it "assigns issue" do
      get :home_issue, number: issue.number

      assigns(:issue).should == issue
    end

    it "assigns current issue" do
      Setting.stub(:current_issue) { issue }

      get :home_issue

      assigns(:issue).should == issue
    end

    it "response 404 for unpublished issue" do
      get :home_issue, number: unpublished_issue.number

      response.should be_not_found
    end

    it "assigns ordered articles" do
      home_articles
      issued_article

      get :home_issue, number: issue.number

      assigns(:articles).should == sorted_home_articles
    end

    it "should not fetch issued article that is not ordered for home" do
      home_articles
      issued_article

      get :home_issue, number: issue.number

      assigns(:articles).should_not include(issued_article)
    end

    it "should not fetch unpublished home article" do
      home_articles
      unpublished_home_article

      get :home_issue, number: issue.number

      assigns(:articles).should_not include(unpublished_home_article)
    end
  end

  describe "GET issued_article" do
    it "renders template issued_article" do
      get :issued_article, { id: issued_article.id,
                             title: issued_article.permalink,
                             name: issued_article.category_permalink,
                             number: issued_article.issue_number }

      response.should render_template(:issued_article)
    end

    it "assigns issue" do
      get :issued_article, { id: issued_article.id,
                             title: issued_article.permalink,
                             name: issued_article.category_permalink,
                             number: issued_article.issue_number }

      assigns(:issue).should be
    end

    it "assigns article" do
      get :issued_article, { id: issued_article.id,
                             title: issued_article.permalink,
                             name: issued_article.category_permalink,
                             number: issued_article.issue_number }

      assigns(:article).should == issued_article
    end

    it "response 404 for unpublished article" do
      get :issued_article, { id: unpublished_issued_article.id,
                             title: unpublished_issued_article.permalink,
                             name: unpublished_issued_article.category_permalink,
                             number: unpublished_issued_article.issue_number }

      response.should be_not_found
    end

    it "redirects to canonical url with wrong article title" do
      get :issued_article, { id: issued_article.id,
                             title: "tralala",
                             name: issued_article.category_permalink,
                             number: issued_article.issue_number }

      response.should redirect_to(article_canonical_path(issued_article,
                                                         issued_article.issue))
    end
  end

  describe "GET issued_category" do
    let(:ordered_articles) do
      issued_category_articles.sort {|a,b| a.ordering.cat_pos <=> b.ordering.cat_pos }
    end

    it "renders template issued_category" do
      get :issued_category, { number: issued_article.issue_number,
                              name: issued_article.category_permalink }

      response.should render_template(:issued_category)
    end

    it "responses 404 for category that not exist" do
      get :issued_category, { number: issued_article.issue_number,
                              name: "ablaoublas" }

      response.should be_not_found
    end

    it "assigns category" do
      get :issued_category, { number: issued_article.issue_number,
                              name: issued_article.category_permalink }

      assigns(:category).should == issued_article.category
    end

    it "assigns articles" do
      get :issued_category, { number: issued_article.issue_number,
                              name: issued_category.permalink }

      assigns(:articles).should == ordered_articles
    end

    it "should not fetch unpublished articles" do
      get :issued_category, { number: issued_article.issue_number,
                              name: issued_category.permalink }

      assigns(:articles).should_not include(:unpublished_issued_article)
    end
  end

  describe "GET not_issued_category" do
    let(:category_articles_desc) do
      category_articles.sort { |a,b| b.date <=> a.date }
    end

    let(:category_articles_asc) do
      category_articles.sort { |a,b| a.date <=> b.date }
    end

    before { Setting.stub(:current_issue) { issue } }

    it "renders not_issued_category" do
      get :not_issued_category, { name: category.permalink }

      response.should render_template(:not_issued_category)
    end

    it "responses 404 for category that not exist" do
      get :not_issued_category, { name: "tralala" }

      response.should be_not_found
    end

    it "assigns category" do
      get :not_issued_category, { name: category.permalink }

      assigns(:category).should == category
    end

    it "assigns articles ordered by date desc" do
      category_articles

      get :not_issued_category, { name: category.permalink }

      assigns(:articles).should == category_articles_desc
    end

    it "assigns articles ordered by date asc" do
      category.update_attribute(:order_articles, 1)
      category_articles

      get :not_issued_category, { name: category.permalink }

      assigns(:articles).should == category_articles_asc
    end

    it "should not fetch unpublished articles" do
      unpublished_category_article

      get :not_issued_category, { name: category.permalink }

      assigns(:articles).should_not include(:unpublished_category_article)
    end
  end

  describe "GET not_issued_article" do
    before { Setting.stub(:current_issue) { issue } }

    it "renders not_issued_article" do
      get :not_issued_article, { id: category_article.id,
                                 name: category.permalink,
                                 title: category_article.permalink }

      response.should render_template(:not_issued_article)
    end

    it "responses 404 for unpublished article" do
      get :not_issued_article, { id: unpublished_category_article.id,
                                 name: category.permalink,
                                 title: unpublished_category_article.permalink }

      response.should be_not_found
    end

    it "assigns category" do
      get :not_issued_article, { id: category_article.id,
                                 name: category.permalink,
                                 title: category_article.permalink }

      assigns(:category).should == category
    end

    it "assigns article" do
      get :not_issued_article, { id: category_article.id,
                                 name: category.permalink,
                                 title: category_article.permalink }

      assigns(:article).should == category_article
    end

    it "redirects to canonical url" do
      get :not_issued_article, { id: category_article.id,
                                 name: category.permalink,
                                 title: "tralala" }

      response.should redirect_to(article_canonical_path(category_article))
    end
  end

  describe "GET feed" do
    it "renders feed.rss.builder" do
      category_articles
      get :feed, { id: category.id, format: "rss" }

      response.should render_template(:feed)
    end

    it "assigns articles" do
      category_articles

      get :feed, id: category.id

      assigns(:articles).should =~ category_articles
    end

  end
end
