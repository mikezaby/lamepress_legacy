# -*- encoding : utf-8 -*-
require 'spec_helper'

describe Page do
  let(:page) { FactoryGirl.create(:page) }
  let(:unpublished_page) { FactoryGirl.create(:page, :unpublished) }

  subject { page }

  it { should have_many(:navigators).dependent(:destroy) }

  it { should ensure_length_of(:name).is_at_most(250) }
  it { should validate_uniqueness_of(:permalink) }
  it { should ensure_length_of(:permalink).is_at_most(99) }
  it { should ensure_length_of(:title).is_at_most(250) }
  it { should ensure_length_of(:meta_description).is_at_most(250) }

  it "should fetch published pages only" do
    Page.published_only.should include(page)
    Page.published_only.should_not include(unpublished_page)
  end
end
