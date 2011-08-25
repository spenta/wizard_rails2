require 'spec_helper'

describe SuperUsage do
  before(:each) do
    %w{Bureautique Internet Mobilite}.each do |super_usage_name|
      Factory(:super_usage, :name => super_usage_name)
    end
  end

  describe 'all_except_mobilities' do
    it 'returns all the super usages which are not mobility-related' do
      expected_super_usages_names = %w{Bureautique Internet}
      actual_super_usages_names = SuperUsage.all_except_mobilities.collect{|su| su.name}
      actual_super_usages_names.should eq(expected_super_usages_names)
    end
  end

  describe 'all_except_mobilities_ids' do
    it 'returns all the ids of the super usages which are not mobility-related' do
      expected_ids = [1, 2]
      actual_ids = SuperUsage.all_except_mobilities_ids
      actual_ids.should eq(expected_ids)
    end
  end
end
