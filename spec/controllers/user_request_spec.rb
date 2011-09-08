require 'spec_helper'

describe UserRequestsController do
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

    session["usage_choices"] = valid_usage_choices
  end

  after(:each) do
    SuperUsage.destroy_all
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
    context 'when session["usage_choices] is valid' do
      before(:each) do
        controller.stub(:validate_usage_choices) {true}
      end

      it 'assign the usages in session["usage_choices"] to @selected_usages' do
        get :first_step
        assigns[:selected_usages].should =~ [1, 2, 3, 6]
      end

      it 'assign all the super usages except mobilities as @super_usages' do
        get :first_step
        assigns[:super_usages].should eq(SuperUsage.non_mobility)
      end

      it 'renders the first_step template' do
        get :first_step
        response.should render_template('first_step')
      end
    end
  end

  describe 'GET second_step' do
    context 'when session["usage_choices] is valid' do
      before(:each) do
        controller.stub(:validate_usage_choices) {true}
      end

      it 'renders the second_step template' do
        get :second_step
        response.should render_template('second_step')
      end
    end
  end

  describe 'GET third_step' do
    context 'when session["usage_choices"] is valid' do
      before(:each) do
        controller.stub(:validate_usage_choices) {true}
      end

      it 'renders the third step template' do
        get :third_step
        response.should render_template('third_step')
      end
    end
  end

  describe 'POST choose_usages' do
    context 'when at least one valid usage is choosen' do
      before(:each) do
        controller.stub(:validate_usage_choices) {true}
        controller.stub(:chosen_usages) {[1, 2, 4]}
      end
      it 'creates a new usage_choices in session with weight_for_user equal to 50 for chosen usages if they are not already chosen. Keep mobility choices unaffected' do
        post :choose_usages
        session[:usage_choices].should eq({
          "usage_1" => "10",
          "usage_2" => "35",
          "usage_4" => "50",
          "usage_7" => "10",
          "usage_8" => "0"
        })
      end

      it 'redirects to the second page of the form' do
        post :choose_usages
        response.should redirect_to(form_second_step_path)
      end
    end

  end

  describe 'POST choose_weights' do
    before(:each) do
      controller.stub(:validate_usage_choices) {true}
    end
    context 'when all the weights are 0' do
      it 'redirects to the second page of the wizard with a message saying that at leat one weight should be greater than 0' do
        post :choose_weights, :super_usage_weight_1=> "0", :super_usage_weight_2 => "0"
        response.should redirect_to(form_second_step_path)
        flash[:error].should eq("no_weights_greater_than_0")
      end
    end
    context 'when at least one weight is > 0' do
      it 'updates the session["usage_choices"] accordingly' do
        post :choose_weights, :super_usage_weight_1=>"40"
        session["usage_choices"]["usage_1"].should eq("40")
        session["usage_choices"]["usage_2"].should eq("40")
      end
      it 'redirects to the third page of the form' do
        post :choose_weights, :super_usage_weight_1=> "40"
        response.should redirect_to(form_third_step_path)
      end
    end
  end

  describe 'POST choose_mobilities' do
    context 'when the request is valid' do
      before :each do
        post :choose_mobilities, :mobility_7 => '13', :mobility_8 => '100'
      end
      it 'updates session["usage_choices"]'
      it 'logs the usage and mobility choices to the database'
      it 'assigns @product_scored'
      it 'assigns @sigmas and @gammas'
      it 'redirects to the recommadations page'
    end
    context 'when the request is invalid'
  end

  #helpers
  describe 'chosen_usages' do
    it 'selects usage id from request parameters' do
      params = {"usage_1" => "1", "usage_2" => "1", "usage_3" => "1"}
      controller.chosen_usages(params).should eq([1, 2, 3])
    end
  end 

  describe 'selected_usages' do
    it 'returns an array of the non mobility usage_ids found in @usage_choices' do
      controller.selected_usages.should eq([])
      controller.usage_choices = valid_usage_choices
      controller.selected_usages.should =~ [1, 2, 3, 6]
    end
  end

  describe 'assign_usage_choices' do
    context 'when the session is invalid' do
      it 'set session["usage_choices"] and @usage_choices to the default usage_choices' do
        controller.stub(:validate_usage_choices) {false}
        controller.assign_usage_choices
        assigns[:usage_choices].should eq(controller.default_usage_choices)
        session["usage_choices"].should eq(controller.default_usage_choices)
      end

      it 'redirects to new_request' do
        #can't have a response without a http request
        controller.stub(:validate_usage_choices) {false}
        get :first_step
        response.should redirect_to(new_request_path)
      end
    end
    context 'when the session is valid' do
      it 'completes session["usage_choices"] with mobility_choices'
      it 'assigns session["usage_choices"] to @usage_choices' do
        controller.stub(:validate_usage_choices) {true}
        controller.assign_usage_choices
        assigns[:usage_choices].should eq(valid_usage_choices)
      end
    end
  end

  describe 'validate_usage_choices' do
    it 'returns true if usage_choices is well-formed and values are valid' do
      controller.validate_usage_choices(valid_usage_choices).should be_true
    end
    it 'returns false if usage_choices is not well-formed' do
      #spelling mistake usage
      usage_choices = {
        "usae_1" => "10",
        "usage_2" => "35",
        "usage_3" => "100",
        "usage_6" => "0",
        "usage_7" => "10",
        "usage_8" => "0"
      }
      controller.validate_usage_choices(usage_choices).should be_false
      #space after usage_1
      usage_choices = {
        "usage_1 " => "10",
        "usage_2" => "35",
        "usage_3" => "100",
        "usage_6" => "0",
        "usage_7" => "10",
        "usage_8" => "0"
      }
      controller.validate_usage_choices(usage_choices).should be_false
    end
    it 'returns false if usage_id are invalid' do
      usage_choices = {
        "usage_10" => "10",
        "usage_2" => "35",
        "usage_3" => "100",
        "usage_6" => "0",
        "usage_7" => "10",
        "usage_8" => "0"
      }
      controller.validate_usage_choices(usage_choices).should be_false
    end
    it 'returns false if usage_choices has an invalid weight' do
      usage_choices = {
        "usage_1" => "-10",
        "usage_2" => "35",
        "usage_3" => "100",
        "usage_6" => "0",
        "usage_7" => "10",
        "usage_8" => "0"
      }
      controller.validate_usage_choices(usage_choices).should be_false
    end
  end

  describe 'default_usage_choices' do
    it 'return a hash {"usage_x" => "0"} where x are mobility ids' do
      controller.default_usage_choices.should eq({
        "usage_7" => "0",
        "usage_8" => "0"
      })
    end
  end
end

private

def valid_usage_choices
  usage_choices = {
    "usage_1" => "10",
    "usage_2" => "35",
    "usage_3" => "100",
    "usage_6" => "0",
    "usage_7" => "10",
    "usage_8" => "0"
  }
end
