class UserRequest < ActiveRecord::Base
  has_many :usage_choices
end
