class UserRequestsController < ActionController::Base
  layout 'application'
  before_filter :assign_usage_choices, :only => [:first_step, :second_step, :third_step, :choose_usages]
  attr_accessor :usage_choices

  def new_request
    reset_session
    redirect_to form_first_step_path
  end

  def first_step
    @super_usages = SuperUsage.non_mobility
    @selected_usages = selected_usages
  end

  def second_step
    if @usage_choices.nil?
      redirect_to new_request_path
    end
  end

  def third_step
  end

  def choose_usages
    #remove unselected usages
    @usage_choices.delete_if do |usage_key, weight_s|
      usage_id = usage_key.split('_').last.to_i
      !(Usage.mobility_ids.include?(usage_id) || chosen_usages(params).include?(usage_id)) 
    end
    #add new usage choices
    chosen_usages.each do |usage_id|
      unless @usage_choices["usage_#{usage_id}"]
        @usage_choices["usage_#{usage_id}"] = "50"
      end
    end
    session[:usage_choices] = @usage_choices
    if @usage_choices.count == Usage.mobility_ids.length #no non-mobility choices
      redirect_to :form_first_step, :flash => {:error => "no_valid_usages"}
    else
      redirect_to :form_second_step
    end
  end

  def choose_weights
    at_least_one_weight = false
    chosen_weights = params.select{|key, value| key =~ /^super_usage_weight_[0-9]+$/ && value =~ /^\d+$/}
    #redirect_to :new_request and return if choosen_weight.empty?
    chosen_weights.each do |super_usage_key, weight_string|
      at_least_one_weight = true if weight_string.to_i > 0
      super_usage_id = super_usage_key.split('_').last.to_i
      super_usage = SuperUsage.where(:super_usage_id => super_usage_id).first
      super_usage.usages.each do |u|
        session["usage_choices"]["usage_#{u.usage_id}"] = weight_string
      end 
    end
    if at_least_one_weight
      redirect_to form_third_step_path
    else
      redirect_to form_second_step_path, :flash => {:error => "no_weights_greater_than_0"}
    end
  end

  def choose_mobilities
    if validate_mobility_choices(chosen_mobilities)
      session["mobility_choices"] = chosen_mobilities
    else
      session["mobility_choices"] = nil
      session["usage_choices"] =nil
      redirect_to form_first_step_path and return if response
    end
    redirect_to recommandations_path
  end

  def recommandations
  end

  #helpers

  def previous_weight super_usage_key
    if @usage_choices && @usage_choices[super_usage_key]
      @usage_choices[super_usage_key]["weight"]
    else
      "50"
    end
  end

  def selected_usages
    result = []
    unless @usage_choices.nil?
      @usage_choices.each_key do |usage_key|
        usage_id = usage_key.split('_').last.to_i 
        result << usage_id if Usage.non_mobility_ids.include?(usage_id)
      end
    end
    result
  end

  def assign_usage_choices
    if session[:usage_choices].nil?
      session["usage_choices"] = default_usage_choices
    else
      if validate_usage_choices(session[:usage_choices])
        @usage_choices = session[:usage_choices] 
      else
        session[:usage_choices] = default_usage_choices
        redirect_to new_request_path and return if response
      end
    end
    @usage_choices = session["usage_choices"]
  end

  def chosen_usages params
    result = []
    params.each_key do |key|
      result << key.split('_').last.to_i if (key =~ /^usage_[0-9]+$/ && is_valid_usage(key))
    end
    result
  end

  def chosen_mobilities
    result = {}
    params.each do |key, value|
      result[key.to_s] = value if key.to_s =~ /mobility_\d+/
    end
    result
  end

  def is_valid_usage usage_name
    usage_id = usage_name.split('_').last.to_i
    Usage.non_mobility_ids.include?(usage_id)
  end

  def validate_usage_choices usage_choices
    #checks that usage_choices looks like
    # {"usage_1" => "19"}
    begin
      throw "usage_choices not well-formed : #{usage_choices.to_s}" unless usage_choices.to_s =~ /\{(\"usage_\d+\"=>\"\d+\"(, )?)+\}/
      usage_choices.each do |usage_key, weight|
        usage_id = usage_key.split('usage_').last.to_i
        throw "invalid weight during session validation : #{weight.to_i}" unless (0..100).include?(weight.to_i)
        throw "invalid usage_id : #{usage_id}" unless Usage.all_ids.include?(usage_id)
      end
    rescue
      return false
    end
  end

  def validate_mobility_choices mobility_choices
    #checks that mobility_choices looks like
    # {"mobility_7" => "18"}
    begin
      throw "mobility_choices not well-formed : #{mobility_choices.to_s}" unless mobility_choices.to_s =~ /\{(\"mobility_\d+\"=>\"\d+\"(, )?)+\}/
      mobility_choices.each_key do |mobility_key|
        mobility_id = mobility_key.split('_').last.to_i
        throw "invalid mobility : #{mobility_key}" unless Usage.all_mobilities_ids.include?(mobility_id)
      end
      return true
    rescue
      return false
    end
  end

  def default_usage_choices
    result = {}
    Usage.mobility_ids.each do |mobility_id|
      result["usage_#{mobility_id}"] = "0"
    end
    result
  end
end
