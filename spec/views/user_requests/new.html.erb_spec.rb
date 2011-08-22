require 'spec_helper'

describe 'user_requests/new.html.erb' do
  before(:each) do
    %w{Bureautique Internet Mobilite}.each do |su_name|
      super_usage = Factory(:super_usage, :name => su_name)
      %w{1 2}.each do |usage_num|
        usage = Factory(:usage, :name =>su_name+"_"+usage_num, :super_usage_id => super_usage.id)
        super_usage.usages << usage
      end
    end
  end

  before(:each) do
    assign(:super_usages, SuperUsage.all_except_mobilities)
    render
  end

  it 'shows a form to submit a newly created user_request' do
    rendered.should have_selector('form', :action => user_requests_path, :method => 'post')
  end

  it 'shows all the super usages and usages except mobilty-related' do
    SuperUsage.all_except_mobilities.each do |su|
      rendered.should have_selector("div#super_usage_#{su.id}")
      su.usages.each do |u|
        rendered.should have_selector("input#usage_#{u.id}")
      end
    end
    mobility = SuperUsage.where(:name => 'Mobilite').first 
    rendered.should_not have_selector("div#super_usage_#{mobility.id}")
  end
end
