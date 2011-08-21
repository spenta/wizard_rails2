require 'spec_helper'

describe SuperUsage do
  describe 'all_except_mobilities' do
    before(:each) do
      Factory(:super_usage, :name => 'Bureautique')
      Factory(:super_usage, :name => 'Internet')
      Factory(:super_usage, :name => 'Mobilite')
    end

    it 'returns all the super usages which are not mobility-related' do
      expected_super_usages_names = %w{Bureautique Internet}
      actual_super_usages_names = SuperUsage.all_except_mobilities.collect{|su| su.name}
      actual_super_usages_names.should eq(expected_super_usages_names)
    end
  end
end
