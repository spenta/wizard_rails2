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
    session["usage_choices"] = bureautique_usage_choices
  end

  after(:each) do
    SuperUsage.reset
    Usage.reset
  end

  describe 'GET new_request' do
    it 'reset the session' do
      get :new_request
      session.should eq({})
    end

    it 'redirects to the first step of the form' do
      get :new_request
      response.should redirect_to(form_first_step_path)
    end
  end

  describe 'GET first_step' do
    context 'when session["usage_choices"] is corrupted' do
      it 'resets the session via new_request' do
        controller.stub(:validate_usage_choices) {false}
        get :first_step
        response.should redirect_to(new_request_path)
      end
    end

    context 'when session["usage_choices] is valid' do
      it 'assigns session["usage_choices"] to @usage_choices' do
        get :first_step
        assigns[:usage_choices].should eq(bureautique_usage_choices) 
      end

      it 'assign the usages in session["usage_choices"] to @selected_usages' do
        get :first_step
        assigns[:selected_usages].should eq([1, 2])
      end

      it 'assign all the super usages except mobilities as @super_usages' do
        get :first_step
        assigns[:super_usages].should eq(SuperUsage.all_except_mobilities)
      end

      it 'renders the first_step template' do
        get :first_step
        response.should render_template('first_step')
      end
    end
  end

  describe 'GET second_step' do
    context 'when session["usage_choices"] is corrupted' do
      it 'redirects to the first page of the wizard with a clean session via new_request' do
        controller.stub(:validate_usage_choices) {false}
        get :second_step
        response.should redirect_to(new_request_path)
      end
    end

    context 'when at least one usage is choosen' do
      it 'assign session["usage_choices"] to @usage_choices' do
        get :second_step
        assigns[:usage_choices].should eq(bureautique_usage_choices) 
      end

      it 'renders the second_step template' do
        get :second_step
        response.should render_template('second_step')
      end
    end
  end

  describe 'POST choose_usages' do
    context 'when at least one valid usage is choosen' do
      it 'creates a new usage_choices in session with weight_for_user equal to 50 for chosen super usages' do
        controller.stub(:chosen_usages) {[1, 2, 3]}
        post :choose_usages 
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

    context 'when no valid usage is selected' do
      it 'redirects to the first page of the wizard with a message saying that the at leat one usage should be selected' do
        post :choose_usages, :usage_0 => "1", :usage_99999 => "1", :usage_qwe => "1", :usage_1a => "1", :usage_7 => "1"
        response.should redirect_to(form_first_step_path)
        flash[:error].should eq("no_valid_usages")
      end
    end
  end

  describe 'POST choose_weights' do
    context 'when all the weights are 0' do
      it 'redirects to the second page of the wizard with a message saying that at leat one weight should be greater than 0' do
        post :choose_weights, :super_usage_1=> "0"
        response.should redirect_to(form_second_step_path)
        flash[:error].should eq("no_weights_greater_than_0")
      end
    end
    context 'when at least one weight is > 0' do
      it 'updates the session["usage_choices"] accordingly' do
        post :choose_weights, :super_usage_weight_1=>"40"
        session["usage_choices"]["super_usage_1"]["weight"].should eq("40")
      end
      it 'redirects to the third page of the form' do
        post :choose_weights, :super_usage_weight_1=> "40"
        response.should redirect_to(form_third_step_path)
      end
    end
  end

  #helpers
  describe 'chosen_usages' do
    it 'selects usage id from request parameters' do
      params = {"usage_1" => "1", "usage_2" => "1", "usage_3" => "1"}
      controller.chosen_usages(params).should eq([1, 2, 3])
    end
  end 

  describe 'selected_usages' do
    it 'returns an array of the usage_id found in @usage_choices' do
      controller.selected_usages.should eq([])
      controller.usage_choices = bureautique_usage_choices
      controller.selected_usages.should eq([1, 2])
    end
  end

  describe 'assign_usage_choices' do
    context 'the session is invalid' do
      it 'set session["usage_choices"] to nil' do
        controller.stub(:validate_usage_choices) {false}
        controller.assign_usage_choices
        assigns[:usage_choices].should be_nil
      end

      it 'redirects to new_request' do
        #can't have a response without a http request
        controller.stub(:validate_usage_choices) {false}
        get :first_step
        response.should redirect_to(new_request_path)
      end
    end
    context 'the session is valid' do
      it 'assigns session["usage_choices"] to @usage_choices' do
        controller.stub(:validate_usage_choices) {true}
        controller.assign_usage_choices
        assigns[:usage_choices].should eq(bureautique_usage_choices)
      end
    end
  end

  describe 'validate_usage_choices' do
    it 'returns true usage_choices is well-formed and values are valid' do
      controller.validate_usage_choices(bureautique_usage_choices).should be_true
    end
    it 'returns false if usage_choices is not well-formed' do
      #spelling mistake on selected_usages
      usage_choices = {"super_usage_1" => {"selected_uages" => "1, 2", "weight" => "23"}}
      controller.validate_usage_choices(usage_choices).should be_false
      #space after super_usage_1
      usage_choices = {"super_usage_1 " => {"selected_usages" => "1, 2", "weight" => "23"}}
      controller.validate_usage_choices(usage_choices).should be_false
    end
    it 'returns false if usage_choices has invalid super_usages' do
      usage_choices = {"super_usage_100" => {"selected_usages" => "1, 2", "weight" => "23"}}
      controller.validate_usage_choices(usage_choices).should be_false
    end
    it 'returns false if usage_choices associates wrong usages to super_usages' do
      usage_choices = {"super_usage_1" => {"selected_usages" => "3, 5", "weight" => "23"}}
      controller.validate_usage_choices(usage_choices).should be_false
    end
    it 'returns false if usage_choices has an invalid weight' do
      usage_choices = {"super_usage_1" => {"selected_usages" => "1, 2", "weight" => "239"}}
      controller.validate_usage_choices(usage_choices).should be_false
    end
  end
end

private

def mock_super_usage
  @mock_super_usage ||= mock_model(SuperUsage) 
end

def bureautique_usage_choices
  usage_choices = {"super_usage_1"=>{"selected_usages"=>"1, 2","weight"=>"23"}}
end
