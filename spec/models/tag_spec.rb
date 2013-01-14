# -*- encoding : utf-8 -*-
require 'spec_helper'
describe Tag do

  subject { FactoryGirl.build(:tag) }

  it { should have_many(:articles).through(:taggings) }
  it { should have_many(:taggings).dependent(:destroy) }
end