# -*- encoding : utf-8 -*-
require 'spec_helper'
describe Article do

  let(:build_article) { FactoryGirl.build(:issued_article) }

  let(:issue) { FactoryGirl.create(:issue, :public) }

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
  let(:other_category_article) { FactoryGirl.create(:article) }

  it { should belong_to(:category) }
  it { should belong_to(:issue) }
  it { should have_one(:ordering).dependent(:delete) }
  it { should have_many(:taggings).dependent(:destroy) }
  it { should have_many(:tags).through(:taggings) }

  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:date) }
  it { should validate_presence_of(:html) }
  it { should validate_presence_of(:category_id) }

  describe "save" do
    subject { build_article }

    it "touches category" do
      subject.category.should_receive(:touch)

      subject.save
    end

    it "touches issue" do
      subject.issue.should_receive(:touch)

      subject.save
    end

    it "assigns tags to article" do
      subject.tag_names = "y0, a tag, random"

      subject.save

      subject.tags.map(&:name).should =~ ["y0", "a tag", "random"]
    end
  end

  describe ".home" do
    it "should have articles that is home ordered" do
      home_articles
      unpublished_home_article

      Article.home.should == sorted_home_articles
    end
  end

  describe ".order_category" do
    let(:ordered_articles) do
      issued_category_articles.sort { |a,b| a.ordering.cat_pos <=> b.ordering.cat_pos }
    end

    it "should have category articles ordered" do
      Article.order_category.should == ordered_articles
    end
  end

  describe ".issued" do
    it "should have issued articles" do
      Article.issued.should include(issued_article)
    end
    it "should not have non issued articles" do
      Article.issued.should_not include(category_article)
    end
  end

  describe ".non_issued" do
    it "should have non issued articles" do
      Article.non_issued.should include(category_article)
    end

    it "should not have issued articles" do
      Article.non_issued.should_not include(issued_article)
    end
  end

  describe ".for_category" do
    it "should have articles of a category" do
      Article.for_category(category.id).should include(category_article)
    end

    it "shouldn't have articles of other category" do
      Article.for_category(category.id).should_not include(other_category_article)
    end
  end
end
