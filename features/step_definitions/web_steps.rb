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
  when 'super usages'
    Factory(:super_usage, :name => 'Bureautique')
    Factory(:super_usage, :name => 'Internet')
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
# -------------------------------------------------
# Then
# -------------------------------------------------
Then /^(?:|I )should be on the (.*) page of the form$/ do |page_number|
  page.should have_css('#form_first_page')
end

Then /^I should see all the super usages$/ do
  SuperUsage.all.each do |su|
    page.should have_css("#super_usage_#{su.id}")
  end
end

Then /^no super usages should be selected$/ do
  SuperUsage.all.each do |su|
    page.should_not have_css(".selected")
  end
end
