# -*- encoding : utf-8 -*-
require 'spec_helper'
describe Tagging do

  subject { FactoryGirl.build(:tagging) }

  it { should belong_to(:article) }
  it { should belong_to(:tag) }

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