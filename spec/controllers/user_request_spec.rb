require 'spec_helper'

describe UserRequestsController do
  before(:each) do
    Factory(:super_usage, :name => 'Bureautique')
    Factory(:super_usage, :name => 'Internet')
    Factory(:usage, :name => "Bureautique_Simple", :id => 1)
  end

  describe 'GET first_step' do
    it 'assign all the super usages except mobilities as @super_usages' do
      SuperUsage.stub(:all_except_mobilities) {[mock_super_usage]}
      get :first_step
      assigns[:super_usages].should eq([mock_super_usage])
    end

    it 'renders the first_step template' do
      get :first_step
      response.should render_template('first_step')
    end
  end

  describe 'POST choose_usages' do
    context 'when at least one valid usage is choosen' do
      it 'creates a new usage_choices in session with usage choices exactly corresponding to choosen usages and weight_for_user equal to 0' do
        post :choose_usages, :usage_1 => "1"
        session[:usage_choices].should eq({"usage_1" => "0"})
      end

      it 'redirects to the second page of the form' do
        post :choose_usages, :usage_1 => "1"
        response.should redirect_to(form_second_step_path)
      end
    end
  end


  context 'when no valid usage is selected' do
    it 'redirects to the first page of the wizard with a message saying that the at leat one usages should be selected' do
      post :choose_usages, :usage_0 => "1", :usage_99999 => "1", :usage_qwe => "1", :usage_1a => "1"
      response.should redirect_to(form_first_step_path)
      flash[:error].should eq("no_valid_usages")
    end
  end
end

private

def mock_super_usage
  @mock_super_usage ||= mock_model(SuperUsage) 
end

