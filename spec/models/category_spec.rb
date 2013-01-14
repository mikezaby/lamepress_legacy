# -*- encoding : utf-8 -*-
require 'spec_helper'

describe Category do
  let(:category) { FactoryGirl.create(:category) }
  let(:issued_category) { FactoryGirl.create(:issued_category) }

  subject { category }

  it { should have_many(:articles) }
  it { should have_many(:navigators).dependent(:destroy) }

  it { should validate_presence_of(:name) }
  it { should validate_uniqueness_of(:permalink) }

  it "should fetch issued categories" do
    Category.issued.should include(issued_category)
    Category.issued.should_not include(category)
  end

  it "should fetch non issued categories" do
    Category.non_issued.should include(category)
    Category.non_issued.should_not include(issued_category)
  end
end
