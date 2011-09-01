class SuperUsageChoice < ActiveRecord::Base
  belongs_to :super_usage
  belongs_to :user_request
end
