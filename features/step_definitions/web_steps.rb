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

Given /^I am on the first page of the wizard form$/ do
  visit new_user_request_path
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

When /^I follow "([^"]*)"$/ do |link|
  click_link(link)
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
  visible_usages = page.all('.question.opened .usage_checkbox')
  visible_usages.size.should eq(num_usages.to_i)
end

Then /^I should see the usage "([^"]*)"$/ do |usage_name|
  usage_id = Usage.where(:name => usage_name).first.id
  page.should have_css(".question.opened #usage_#{usage_id}")
end

Then /^I should not see the usage "([^"]*)"$/ do |usage_name|
  usage_id = Usage.where(:name => usage_name).first.id
  page.should_not have_css(".question.opened #usage_#{usage_id}")
end
