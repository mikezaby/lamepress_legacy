# -*- encoding : utf-8 -*-
require 'spec_helper'
describe Navigator do

  let(:block) { FactoryGirl.create(:block) }

  let(:navigator) { FactoryGirl.create(:navigator) }
  let(:navigator_list) { FactoryGirl.create_list(:navigator, 3, block: block) }

  let(:sorted_navigator_list) { navigator_list.sort { |a,b| a.position <=> b.position } }

  it { should belong_to(:block) }
  it { should belong_to(:navigatable) }

  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:block_id) }
  it { should validate_presence_of(:navigatable_id) }
  it { should validate_presence_of(:navigatable_type) }

  describe "save" do
    subject { FactoryGirl.build(:navigator) }

    it "touches block" do
      subject.block.should_receive(:touch)

      subject.save
    end
  end

  describe ".list" do
    it "fetches all navigators sorted for a block" do
      Navigator.list(block.id).should == sorted_navigator_list
    end

    it "should not have navigator from other block" do
      Navigator.list(block.id).should_not include(navigator)
    end
  end
end
