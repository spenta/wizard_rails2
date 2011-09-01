class UserRequest < ActiveRecord::Base
  has_many :usage_choices
  has_many :super_usage_choices
end
