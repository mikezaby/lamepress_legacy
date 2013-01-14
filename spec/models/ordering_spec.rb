# -*- encoding : utf-8 -*-
require 'spec_helper'
describe Ordering do

  let(:issue_ordering) { FactoryGirl.create(:issue_ordering) }
  let(:issue_orderings) { FactoryGirl.create_list(:issue_ordering, 3) }
  let(:category_ordering) { FactoryGirl.create(:category_ordering) }
  let(:category_orderings) { FactoryGirl.create_list(:category_ordering, 3) }
  let(:article){ FactoryGirl.create(:article) }

  it { should belong_to(:article) }

  describe "save" do
    subject { FactoryGirl.build(:ordering, article: article) }

    it "touches article" do
      subject.article.should_receive(:touch)

      subject.save
    end
  end

  describe ".issue" do
    it "should have only orderings with issue_pos" do
      issue_ordering
      category_ordering

      Ordering.issue.should include(issue_ordering)
      Ordering.issue.should_not include(category_ordering)
    end

    it "should have only orderings with issue_pos" do
      issue_orderings

      Ordering.issue.should == issue_orderings.sort_by(&:issue_pos)
    end
  end

  describe ".categoyr" do
    it "should have only orderings with issue_pos" do
      category_orderings

      Ordering.category.should == category_orderings.sort_by(&:cat_pos)
    end
  end
end
