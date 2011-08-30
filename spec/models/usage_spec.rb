require 'spec_helper'

describe Usage do
  before(:each) do
    id = 1
    %w{Bureautique Internet Mobilite}.each do |super_usage_name|
      super_usage = Factory(:super_usage, :name => super_usage_name)
      [1, 2].each do |usage_number|
        Factory(:usage, :name => "#{super_usage_name}_#{usage_number}", :super_usage_id => super_usage.id, :id => id)
        id += 1
      end
    end
  end

  describe 'all_except_mobilities' do
    it 'returns all the usages which are not mobility-related' do
      expected_usages_names = %w{Bureautique_1 Bureautique_2 Internet_1 Internet_2}
      actual_usages_names = Usage.all_except_mobilities.collect{|u| u.name}
      actual_usages_names.should eq(expected_usages_names)
    end
  end

  describe 'all_except_mobilities_ids' do
    it 'returns all the ids of the usages which are not mobility-related' do
      expected_ids = [1, 2, 3, 4]
      actual_ids = Usage.all_except_mobilities_ids
      actual_ids.should eq(expected_ids)
    end
  end

  describe 'all_mobilities' do
    it 'return all the mobility-related usage' do
      expected_mobilities_names = %w{Mobilite_1 Mobilite_2}
      actual_mobilities_names = Usage.all_mobilities.collect{|u| u.name}
      actual_mobilities_names.should eq(expected_mobilities_names)
    end
  end
end
