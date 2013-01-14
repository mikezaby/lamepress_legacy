# -*- encoding : utf-8 -*-
require 'spec_helper'
describe Banner do

  let(:block) { FactoryGirl.create(:block) }

  let(:banner) { FactoryGirl.create(:banner) }
  let(:banner_with_url) { FactoryGirl.create(:banner, :with_url, block: block) }
  let(:block_banners) { FactoryGirl.create_list(:banner, 3, block: block) }

  let(:sorted_block_banners) { block_banners.sort { |a,b| a.position <=> b.position } }

  subject { FactoryGirl.build(:banner) }

  it { should belong_to(:block) }

  it { should validate_presence_of(:block_id) }
  it { should validate_attachment_presence(:photo) }
  it { should validate_attachment_content_type(:photo).
                allowing('image/jpeg','image/png', 'image/gif') }

  describe "save" do
    it "touches block" do
      subject.block.should_receive(:touch)

      subject.save
    end
  end

  describe ".get_banner" do
    it "fetches all banners sorted for a block" do
      Banner.get_banner(block.id).should == sorted_block_banners
    end

    it "should not have banner from other block" do
      Banner.get_banner(block.id).should_not include(banner)
    end
  end

  describe "#path" do
    it "returns photo url" do
      banner.path.should == banner.photo.url
    end

    it "returns the url of the url field" do
      banner_with_url.path.should == banner_with_url.url
    end
  end
end
