class SuperUsage
  include Mongoid::Document
  field :name
  field :super_usage_id, type: Integer
  field :is_mobility, type: Boolean
  embeds_many :usages
  scope :non_mobility, where(:is_mobility => false)
  scope :mobility, where(:is_mobility => true)
end
