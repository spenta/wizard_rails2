require 'spec_helper'

describe UserRequestsController do
  before(:each) do
    Factory(:super_usage, :name => 'Bureautique')
    Factory(:super_usage, :name => 'Internet')
  end
  describe 'GET new' do
    it 'assign all the super usages except mobilities as @super_usages' do
      SuperUsage.stub(:all_except_mobilities) {[mock_super_usage]}
      get :new
      assigns[:super_usages].should eq([mock_super_usage])
    end

    it 'renders the new template' do
      get :new
      response.should render_template('new')
    end
  end
end

private

def mock_super_usage
  @mock_super_usage ||= mock_model(SuperUsage) 
end

