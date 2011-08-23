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

  describe 'POST' do
    context 'when at least one valid usage is choosen' do
      it 'creates a new user_request record with usage choices exactly corresponding to choosen usages and no weight_for_user'
      it 'redirects to the second page of the form'
    end
    context 'when no valid usage is selected' do
      it 'redirects to the first page of the wizard with a message saying that the chosen usages are invalid'
    end
  end
end

private

def mock_super_usage
  @mock_super_usage ||= mock_model(SuperUsage) 
end

