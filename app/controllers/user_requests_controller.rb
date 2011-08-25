class UserRequestsController < ActionController::Base
  layout 'application'

  def first_step
    @super_usages = SuperUsage.all_except_mobilities
  end

  def second_step
  end

  def choose_usages
    usage_choices = {}
    chosen_usages.each {|u| usage_choices[u] = "50"}
      if usage_choices.empty?
        redirect_to :form_first_step, :flash => {:error => "no_valid_usages"}
      else
        session[:usage_choices] = usage_choices
        redirect_to :form_second_step
      end
  end

  private

  def chosen_usages
    result = []
    params.each_key do |key|
      result << key if (key =~ /^usage_[0-9]+$/ && is_valid_usage(key))
    end
    result
  end

  def is_valid_usage usage_name
    usage_id = usage_name.split('_').last.to_i
    begin
      Usage.find(usage_id)
    rescue ActiveRecord::RecordNotFound
      return false
    end
    true
  end
end
