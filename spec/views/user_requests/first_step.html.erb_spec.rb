require 'spec_helper'

describe 'user_requests/first_step.html.erb' do
  before(:each) do
    fabricate_super_usages
    assign(:super_usages, SuperUsage.non_mobility)
    assign(:selected_usages, [1, 2])
  end

  after(:each) do
    SuperUsage.destroy_all
    Usage.reset
  end

  it 'shows a form to submit a newly created user_request' do
    render
    rendered.should have_selector('form', :action => choose_usages_path, :method => 'post')
  end

  it 'shows all the super usages and usages except mobilty-related' do
    render
    SuperUsage.non_mobility.each do |su|
      rendered.should have_selector("div#super_usage_#{su.super_usage_id}")
      su.usages.each do |u|
        rendered.should have_selector("input#usage_#{u.usage_id}")
      end
    end
    mobility = SuperUsage.mobility.first 
    rendered.should_not have_selector("div#super_usage_#{mobility.super_usage_id}")
  end

  it 'selects usages which are in @selected_usages' do
    assign(:selected_usages, [1, 2])
    render
    rendered.should have_xpath("//input[@type=\'checkbox\' and @checked=\'checked'\]", :count => 2)
    [1, 2].each do |usage_id|
      rendered.should have_xpath("//input[@id=\'usage_#{usage_id}\' and @checked=\'checked\']")
    end
  end

end
