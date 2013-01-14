# -*- encoding : utf-8 -*-
require 'spec_helper'
describe Block do

  let(:block) { FactoryGirl.create(:block) }
  let(:left_block) { FactoryGirl.create_list(:block, 3, :left) }
  let(:left_block_sorted) { left_block.sort { |a,b| a.position <=> b.position } }

  it { should have_many(:navigators).dependent(:destroy) }
  it { should have_many(:banners).dependent(:destroy) }

  describe ".place" do
    it "fetch blocks ordered for a placement" do
      Block.place("left").should == left_block_sorted
    end

    it "should not have blocks for other placement" do
      Block.place("left").should_not include(:block)
    end
  end
end
