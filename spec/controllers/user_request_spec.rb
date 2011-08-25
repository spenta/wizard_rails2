require 'spec_helper'

describe UserRequestsController do
  before(:each) do
    super_usage_id = 1
    usage_id = 1
    %w{Bureautique Internet Jeux Mobilite}.each do |super_usage_name|
      super_usage = Factory(:super_usage, :name => super_usage_name, :id => super_usage_id)
      [1, 2].each do |usage_number|
        Factory(:usage, :name => "#{super_usage_name}_#{usage_number}", :super_usage_id => super_usage_id, :id => usage_id)
        usage_id += 1
      end
      super_usage_id += 1
    end
  end

  after(:each) do
    SuperUsage.reset
    Usage.reset
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

  describe 'GET second_step' do
    context 'when session["usage_choices"] is corrupted'
    it 'redirects to the first page of the wizard with a clean session["usage_choices"] and an error message' do
      session["usage_choices"] = {"super_usage_10" => {"selected_usages" => "1, 2", "weight" => "23"}}
      get :second_step
      assigns[:usage_choices].should be_nil 
      response.should redirect_to(form_first_step_path)

      session["usage_choices"] = {"super_usage_1" => {"selected_usages" => "7", "weight" => "23"}}
      get :second_step
      assigns[:usage_choices].should be_nil 
      response.should redirect_to(form_first_step_path)

      session["usage_choices"] = {"super_usage_1" => {"selected_usages" => "1, 2", "weight" => "230"}}
      get :second_step
      assigns[:usage_choices].should be_nil 
      response.should redirect_to(form_first_step_path)

      #spelling mistake on selectd_usages
      session["usage_choices"] = {"super_usage_1 " => {"selected_uages" => "1, 2", "weight" => "23"}}
      get :second_step
      assigns[:usage_choices].should be_nil 
      response.should redirect_to(form_first_step_path)
    end

    it 'renders the second_step template' do
      session["usage_choices"] = {"super_usage_1 " => {"selected_usages" => "1, 2", "weight" => "23"}}
      get :second_step
      response.should render_template('second_step')
    end
  end

  describe 'POST choose_usages' do
    context 'when at least one valid usage is choosen' do
      it 'creates a new usage_choices in session with weight_for_user equal to 50 for chosen super usages' do
        post :choose_usages, :usage_1 => "1", :usage_2 => "1", :usage_3 => "1"
        session[:usage_choices].should eq({
          "super_usage_1" => {"selected_usages" => "1, 2", "weight" => "50"},
          "super_usage_2" => {"selected_usages" => "3", "weight" => "50"}
        })
      end

      it 'redirects to the second page of the form' do
        post :choose_usages, :usage_1 => "1"
        response.should redirect_to(form_second_step_path)
      end
    end
  end


  context 'when no valid usage is selected' do
    it 'redirects to the first page of the wizard with a message saying that the at leat one usages should be selected' do
      post :choose_usages, :usage_0 => "1", :usage_99999 => "1", :usage_qwe => "1", :usage_1a => "1", :usage_7 => "1"
      response.should redirect_to(form_first_step_path)
      flash[:error].should eq("no_valid_usages")
    end
  end
end

private

def mock_super_usage
  @mock_super_usage ||= mock_model(SuperUsage) 
end

