# -*- encoding : utf-8 -*-
require 'spec_helper'
describe Tagging do

  subject { FactoryGirl.build(:tagging) }

  it { should belong_to(:article) }
  it { should belong_to(:tag) }
  it { should validate_uniqueness_of(:tag_id).scoped_to(:article_id) }

  describe "save" do
    it "touches article" do
      subject.article.should_receive(:touch)

      subject.save
    end

    it "touches tag" do
      subject.tag.should_receive(:touch)

      subject.save
    end
  end
end
