# -*- encoding : utf-8 -*-
require 'spec_helper'
describe Issue do

  let(:issue) { FactoryGirl.create(:issue, :public) }
  let(:unpublished_issue) { FactoryGirl.create(:issue) }
  let(:next_month_issue) { FactoryGirl.create(:issue, :public, :next_month) }
  let(:previus_month_issue) { FactoryGirl.create(:issue, :public, :previus_month) }

  subject { FactoryGirl.build(:issue) }

  it { should have_many(:articles) }

  it { should validate_presence_of(:number) }
  it { should validate_presence_of(:date) }
  it { should validate_attachment_presence(:cover) }
  it { should validate_attachment_content_type(:cover).
                allowing('image/jpeg','image/png', 'image/gif') }
  it { should validate_attachment_presence(:pdf) }
  it { should validate_attachment_content_type(:pdf).
                allowing('application/pdf') }

  it "should fetch published issues" do
    Issue.published_only.should include(issue)
    Issue.published_only.should_not include(unpublished_issue)
  end

  it "should fetch non published issues" do
    Issue.unpublished_only.should include(unpublished_issue)
    Issue.unpublished_only.should_not include(issue)
  end

  describe ".search_issues" do
    let(:today) { Date.today }

    describe "for all issues" do
      it "includes public issues of this month" do
        issue

        issues = Issue.search_issues(today.year, today.month, false)

        issues.should include(issue)
      end

      it "includes unpublished issues of this month" do
        unpublished_issue

        issues = Issue.search_issues(today.year, today.month, false)

        issues.should include(unpublished_issue)
      end

      it "should not include issues of the next month" do
        next_month_issue

        issues = Issue.search_issues(today.year, today.month, false)

        issues.should_not include(next_month_issue)
      end

      it "should not include issues of the previus month" do
        previus_month_issue

        issues = Issue.search_issues(today.year, today.month, false)

        issues.should_not include(previus_month_issue)
      end
    end

    describe "for published issues" do
      it "should not include unpublished issues of this month" do
        unpublished_issue

        issues = Issue.search_issues(today.year, today.month, true)

        issues.should_not include(unpublished_issue)
      end

      it "it should be equal without pass published parameter" do
        issue
        unpublished_issue

        scope1 = Issue.search_issues(today.year, today.month, true)
        scope2 = Issue.search_issues(today.year, today.month)

        scope1.should == scope2
      end
    end
  end
end
