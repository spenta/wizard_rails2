require 'spec_helper'

describe Usage do
  before(:each) do
    super_usage_id = 1
    usage_id = 1
    %w{Bureautique Internet Jeux Mobilite}.each do |super_usage_name|
      is_mobility = (super_usage_name == "Mobilite")
      super_usage = Fabricate(:super_usage, :name => super_usage_name, :super_usage_id => super_usage_id, :is_mobility => is_mobility)
      [1, 2].each do |usage_number|
        Fabricate(:usage, :name => "#{super_usage_name}_#{usage_number}", :super_usage => super_usage, :usage_id => usage_id)
        usage_id += 1
      end
      super_usage_id += 1
    end
  end

  after(:each) do
    SuperUsage.destroy_all
    Usage.reset
  end

  describe 'mobility_ids' do
    it 'returns an array with all the mobility related usage id' do
      Usage.mobility_ids.should eq([7, 8])
    end
  end

  describe 'non_mobility_ids' do
    it 'returns an array with all the non_mobility related usage id' do
      Usage.non_mobility_ids.should =~ (1..6).to_a
    end
  end
end
