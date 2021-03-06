class UserRequestsController < ActionController::Base
  layout 'application'
  before_filter :assign_usage_choices, :only => [:first_step, :second_step, :third_step, :choose_usages]
  attr_accessor :usage_choices

  def new_request
    reset_session
    redirect_to form_first_step_path
  end

  def first_step
    @super_usages = SuperUsage.all_except_mobilities
    @selected_usages = selected_usages
  end

  def second_step
    if @usage_choices.nil?
      redirect_to new_request_path
    end
  end

  def third_step
    session["mobility_choices"] = nil if !validate_mobility_choices(session["mobility_choices"])
    @mobility_choices = {}
    if session["mobility_choices"].nil?
      Usage.all_mobilities_ids.each {|mobility_id| @mobility_choices[mobility_id] = 0}
    else
      Usage.all_mobilities_ids.each do |mobility_id|
        @mobility_choices[mobility_id] = session["mobility_choices"]["mobility_#{mobility_id}"].to_i || 0
      end
    end
  end

  def choose_usages
    usage_choices = {}
    chosen_usages(params).each do |usage_id|
      usage = Usage.find(usage_id)
      super_usage_key = "super_usage_#{usage.super_usage_id}"
      usage_choices[super_usage_key] ||= {}
      usage_choices[super_usage_key]["selected_usages"] ||= ""
      usage_choices[super_usage_key]["selected_usages"] += ", #{usage_id}"
      usage_choices[super_usage_key]["selected_usages"].gsub!(/^(, )/, "")
      usage_choices[super_usage_key]["weight"] = previous_weight(super_usage_key)
    end
    if usage_choices.empty?
      session[:usage_choices] = nil
      redirect_to :form_first_step, :flash => {:error => "no_valid_usages"}
    else
      session[:usage_choices] = usage_choices
      redirect_to :form_second_step
    end
  end

  def choose_weights
    at_least_one_weight = false
    chosen_weights = params.select{|key, value| key =~ /^super_usage_weight_[0-9]+$/ && value =~ /^\d+$/}
    chosen_weights.each do |super_usage_key, weight_string|
      at_least_one_weight = true if weight_string.to_i > 0
      session["usage_choices"][super_usage_key.gsub('_weight','')]["weight"]=weight_string
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
      @usage_choices.each_value do |super_usage_value|
        super_usage_value["selected_usages"].split(', ').each do |usage_id|
          result << usage_id.to_i
        end
      end
    end
    result
  end

  def assign_usage_choices
    unless session[:usage_choices].nil?
      if validate_usage_choices(session[:usage_choices])
        @usage_choices = session[:usage_choices] 
      else
        session[:usage_choices] = nil
        redirect_to new_request_path and return if response
      end
    end
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
    Usage.all_except_mobilities_ids.include?(usage_id)
  end

  def validate_usage_choices usage_choices
    #checks that usage_choices looks like
    # {"super_usage_1" => {"selected_usages" => "2", "weight" => "23"}}
    begin
      throw "usage_choices not well-formed : #{usage_choices.to_s}" unless usage_choices.to_s =~ /\{(\"super_usage_\d+\"=>\{\"selected_usages\"=>\"\d+(, \d+)*\", \"weight\"=>\"\d+\"\}(, )?)+\}/
      usage_choices.each do |super_usage_key, super_usage_value|
        super_usage_id = super_usage_key.split('super_usage_').last.to_i
        throw "invalid mobilit-related super_usage" unless SuperUsage.all_except_mobilities_ids.include?(super_usage_id)
        usage_ids = super_usage_value["selected_usages"].split(", ")
        usage_ids.each do |u_id| 
          throw "invalid usage/super_usage association during session validation" unless Usage.find(u_id).super_usage_id == super_usage_id
        end
        weight = super_usage_value["weight"].to_i
        throw "invalid weight during session validation : #{weight}" unless (0..100).include?(weight)
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
end
