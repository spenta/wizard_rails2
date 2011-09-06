# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :usage_choice do
      weight_for_user 1.5
      usage_id 1
      user_request_id 1
      is_selected false
    end
end