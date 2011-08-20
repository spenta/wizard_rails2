require 'spec_helper'

describe 'user_requests/new.html.erb' do
  before(:all) do
    %w{Bureautique Internet}.each do |su_name|
      super_usage = Factory(:super_usage, :name => su_name)
      %w{1 2}.each do |usage_num|
        usage = Factory(:usage, :name =>su_name+"_"+usage_num, :super_usage_id => super_usage.id)
        super_usage.usages << usage
      end
    end
  end

  before(:each) do
    assign(:super_usages, SuperUsage.all)
    render
  end

  it 'shows a form to submit a newly created user_request' do
    rendered.should have_selector('form', :action => user_requests_path, :method => 'post')
  end

  it 'shows all the super usages and usages' do
    SuperUsage.all.each do |su|
      rendered.should have_selector("div#super_usage_#{su.id}")
      su.usages.each do |u|
        rendered.should have_selector("input#usage_#{u.id}")
      end
    end
  end
end
