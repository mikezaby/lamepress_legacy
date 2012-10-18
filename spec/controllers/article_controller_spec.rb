require 'spec_helper'

describe ArticleController do

  before(:each) do
    ActiveRecord::Base.observers.disable(:article_sweeper)
    ActiveRecord::Base.observers.disable(:ordering_sweeper)
    ActiveRecord::Base.observers.disable(:category_sweeper)
    Issue.any_instance.stub(:expire_cache).and_return(true)
  end

  describe '#Issued' do

    context '#All published' do
      before(:each) do
        @article = FactoryGirl.create(:issued_article)
        @issue = @article.issue
        @category = @article.category
      end
      let(:home_articles) { FactoryGirl.create_list(:article, 3,
                                                    :issue_ordered, :issued,
                                                    issue: @issue) }
      let(:category_articles) { FactoryGirl.create_list(:article, 2,
                                                    :category_ordered, :issued,
                                                    issue: @issue,
                                                    category: @category) }

      it "should get issue home, with listed articles and proper ordered" do
        home_articles
        get :home_issue, { number: @issue.number }
        response.should be_ok

        assigns(:issue).should == @issue
        assigns(:url).should == home_issue_path(@issue.number)

        assigns(:articles).should == home_articles.sort_by { |article| article.ordering.issue_pos }
      end

      it "should get category articles" do
        articles = category_articles.sort_by { |article| article.ordering.cat_pos }
        articles << @article

        get :issued_category, { number: @issue.number, name: @category.permalink }
        response.should be_ok

        assigns(:issue).should == @issue
        assigns(:articles).should == articles

        assigns(:url).should == issued_category_path(number: @issue.number,
                                                     name: @category.permalink)
      end

      it "should show article" do
        get :issued_article, { id: @article.id, title: @article.title,
                              name: @category.permalink, number: @issue.number }
        response.should be_ok

        assigns(:issue).should ==  @issue
        assigns(:article).should == @article
        assigns(:url).should == issued_article_path(number: @issue.number,
                                                    name: @category.permalink,
                                                    id: @article.id,
                                                    title: @article.prettify_permalink)
      end

      it "should redirect to article with category that contain one article" do
        get :issued_category, { number: @issue.number, name: @category.permalink }
        response.should redirect_to(issued_article_path(number: @issue.number,
                                                        name: @category.permalink,
                                                        id: @article.id,
                                                        title: @article.prettify_permalink))
      end
    end

    context '#Unpublished issue' do
      before(:each) do
        @article = FactoryGirl.create(:article, :issue_ordered, :unpublished_issue)
        @issue = @article.issue
        @category = @article.category
      end

      it "should not get issue home for unpublished issue" do
        get :home_issue, { number: @issue.number }
        response.response_code.should == 404

        assigns(:articles).should be_empty
      end

      it "should not get category for unpublished issue" do
        get :issued_category, { number: @issue.number, name: @category.permalink }
        response.response_code.should == 404

        assigns(:articles).should be_empty
      end

      it "should not show article with unpublished issue" do
        get :issued_article, { id: @article.id, title: @article.title,
                              name: @category.permalink, number: @issue.number }
        response.response_code.should == 404

        assigns(:article).should be_nil
      end
    end

    context '#Unpublished article' do
      before(:each) do
        @article = FactoryGirl.create(:article, :issue_ordered, :issued)
        @issue = @article.issue
        @category = @article.category
        @unpub_article = FactoryGirl.create(:article, :unpublished,
                                            :issue_ordered,issue: @issue,
                                            category: @category)
      end
      let(:aditional_article) { FactoryGirl.create(:article, :issue_ordered,
                                                   issue: @issue,
                                                   category: @category) }

      it "should not have unpublished articles in home" do
        get :home_issue, { number: @issue.number }
        response.should be_ok

        assigns(:articles).should_not include(@unpub_article)
      end

      it "should not have unpublished articles in category" do
        aditional_article
        get :issued_category, { number: @issue.number, name: @category.permalink }
        response.should be_ok

        assigns(:articles).should_not include(@unpub_article)
      end

      it "should not show unpublished article" do
        get :issued_article, { id: @unpub_article.id, title: @unpub_article.title,
                              name: @category.permalink, number: @issue.number }

        response.response_code.should == 404
      end

    end


  end

  context '#Non Issued' do
    before(:each) do
      @issue = FactoryGirl.create(:public_issue)
      @category = FactoryGirl.create(:category)
      @articles = FactoryGirl.create_list(:not_issued_article, 2,
                                          category: @category)
    end
    let(:article) { FactoryGirl.create(:not_issued_article, category: @category) }
    let(:issued_article) { FactoryGirl.create(:issued_article) }
    let(:issued_category) { FactoryGirl.create(:category) }
    let(:unpublished_article) { FactoryGirl.create(:not_issued_article,
                                                  :unpublished,
                                                  category: @category) }

    it "should get category articles" do
      get :not_issued_category, { name: @category.permalink }
      response.should be_ok

      assigns(:issue).should == @issue
      assigns(:articles).should == @articles

      assigns(:url).should == not_issued_category_path(name: @category.permalink,
                                                       page: 1)
    end

    it "should not have unpublished articles in category" do
      unpublished_article
      get :not_issued_category, { name: @category.permalink }
      response.should be_ok

      assigns(:issue).should == @issue
      assigns(:articles).should == @articles
      assigns(:articles).should_not include(unpublished_article)

      assigns(:url).should == not_issued_category_path(name: @category.permalink,
                                                       page: 1)
    end

    it "should get 404 for category that is issued" do
      get :not_issued_category, { name: issued_category.permalink }
      response.response_code.should == 404
    end

    it "should get 404 for category that dosn't exist" do
      get :not_issued_category, { name: "bazinga" }
      response.response_code.should == 404
    end

    it "should show article" do
      get :not_issued_article, { name: @category.permalink,
                                 id: @articles.first.id,
                                 title: @articles.first.title }
      response.should be_ok

      assigns(:issue).should == @issue
      assigns(:article).should == @articles.first

      assigns(:url).should == not_issued_article_path(name: @category.permalink,
                                                      id: @articles.first.id,
                                                      title: @articles.first.title)
    end

    it "should get 404 for article that belong to issue" do
      get :not_issued_article, { name: issued_article.category.permalink,
                                 id: issued_article.id,
                                 title: issued_article.title }
      response.response_code.should == 404
    end

    it "should not show unpublished article" do
      get :not_issued_article, { name: unpublished_article.category.permalink,
                                 id: unpublished_article.id,
                                 title: unpublished_article.title }
      response.response_code.should == 404
    end

  end

end