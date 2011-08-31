require 'uri'
require 'cgi'
require File.expand_path(File.join(File.dirname(__FILE__), "..", "support", "paths"))
require File.expand_path(File.join(File.dirname(__FILE__), "..", "support", "selectors"))
require File.expand_path(File.join(File.dirname(__FILE__), "..", "support", "helpers"))

module WithinHelpers
  def with_scope(locator)
    locator ? within(*selector_for(locator)) { yield } : yield
  end
end
World(WithinHelpers)
World(WebStepsHelpers)

# -------------------------------------------------
# Given
# -------------------------------------------------
Given /^I am on the (.+) page$/ do |page_name|
  visit path_to(page_name)
end

Given /^I am on the (.+) page of the wizard form$/ do |page_number|
  form_path = Rails.application.routes.url_helpers.method("form_#{page_number}_step_path")
  visit form_path.call
end

Given /^a set of (.+)$/ do |model|
  case model
  when 'super usages with usages'
    %w{Bureautique Internet Mobilite}.each do |su_name|
      super_usage = Factory(:super_usage, :name => su_name)
      %w{1 2 3}.each do |usage_num|
        if (su_name == 'Internet' || usage_num.to_i < 3)
          usage = Factory(:usage, :name =>su_name+"_"+usage_num, :super_usage_id => super_usage.id) 
          super_usage.usages << usage
        end
      end
    end
  else
    raise "invalid step definition : don't know how to make a set of '#{model}'"
  end
end
# -------------------------------------------------
# When
# -------------------------------------------------
When /^I do nothing$/ do
end

When /^I click on the "([^"]*)" super usage$/ do |super_usage_name|
  super_usage = SuperUsage.find_by_name(super_usage_name)
  page.find('#super_usage_'+super_usage.id.to_s).click
end

When /^I click on "([^"]*)"/ do |name|
  case name
  when "validate usages"
    page.find('.question.opened .validate').click
  when "next page"
    click_button("next-button")
  when "back"
    page.find('.prev-button').click
  else
    raise "not a valid destination"
  end
end

When /^I follow "([^"]*)"$/ do |link|
  click_link(link)
end

When /^I choose the "([^"]*)" usage$/ do |usage_name|
  if usage_name == "cancel"
    page.find(".checkbox.none .name").click
  else
    usage_id = Usage.find_by_name(usage_name).id
    page.find(".usage_name_#{usage_id}").click
  end
end

When /^I set the weight for the super usage "([^"]*)" to (\d+)$/ do |super_usage_name, weight|
  super_usage = SuperUsage.find_by_name super_usage_name
  handler = page.find("#super_usage_#{super_usage.id} .ui-slider-handle")
  case weight
  when "0"
    # drag the handle to the super usage icon to the left  to simulate a drag and drop to the left end of the slider
    target = page.find(".qicon")
    handler.drag_to(target)
  else
    raise "no action defined for this weight"
  end
end

# -------------------------------------------------
# Then
# -------------------------------------------------
Then /^(?:|I )should be on the (.*) page of the form$/ do |page_number|
  page.should have_css(".#{page_number}_page")
end

Then /^I should see all the super usages$/ do
  SuperUsage.all_except_mobilities.each do |su|
    page.should have_css("#super_usage_#{su.id}")
  end
end

Then /^no super usages should be selected$/ do
  SuperUsage.all_except_mobilities.each do |su|
    page.should_not have_css(".selected")
  end
end

Then /^I should see a number of ([0-9]+) usages$/ do |num_usages|
  visible_usages = page.all('.question.opened .usage_name')
  visible_usages.size.should eq(num_usages.to_i)
end

Then /^I should see the usage "([^"]*)"$/ do |usage_name|
  usage_id = Usage.find_by_name(usage_name).id
  page.should have_css(".question.opened #usage_#{usage_id}")
end

Then /^I should not see the usage "([^"]*)"$/ do |usage_name|
  usage_id = Usage.find_by_name(usage_name).id
  page.should_not have_css(".question.opened #usage_#{usage_id}")
end

Then /^the "([^"]*)" super usage (.*) be validated$/ do |super_usage_name, should_be_validated|
  super_usage_id = SuperUsage.find_by_name(super_usage_name).id
  selector = "#super_usage_#{super_usage_id}.selected"
  (should_be_validated == "should") ? page.should(have_css(selector)) : page.should_not(have_css(selector))
end

Then /^I should (.*)see an error message$/ do |yes_or_no|
  case yes_or_no
  when ""
    page.should have_css('.warning')
  when "not "
    page.should_not have_css('.warning')
  else
    raise "invalid step"
  end
end

Then /^I should see only the super usage "([^"]*)"$/ do |super_usage_name|
  selected_super_usage = SuperUsage.find_by_name super_usage_name
  page.should have_css("#super_usage_#{selected_super_usage.id}")
  SuperUsage.all.each do |su|
    page.should_not have_css("#super_usage_#{su.id}") unless su.id == selected_super_usage.id
  end
end

Then /^the weight of "([^"]*)" should be (\d+)$/ do |super_usage_name, weight|
  super_usage = SuperUsage.find_by_name super_usage_name
  page.should have_xpath("//select[@id = \"super_usage_weight_#{super_usage.id}\"]/option[@value = \"#{weight}\"]")
end

Then /^I should see all the mobilities$/ do
  Usage.all_mobilities.each do |m|
    page.should have_css("#mobility_#{m.id}")
  end
end

Then /^the weight of the "([^"]*)" mobility should be (\d+)$/ do |mobility_name, weight|
  mobility = Usage.find_by_name mobility_name
  page.should have_xpath("//select[@id = \"mobility_weight_#{mobility.id}\"]/option[@value = \"#{weight}\"]")
end
