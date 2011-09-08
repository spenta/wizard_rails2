class Usage
  include Mongoid::Document
  field :name
  field :usage_id, type: Integer
  embedded_in :super_usage
  
  def self.mobility_ids
    @@mobility_ids ||= build_mobility_ids
  end

  def self.build_mobility_ids
    result = []
    SuperUsage.mobility.each do |super_mobility|
      super_mobility.usages.each {|mobility| result << mobility.usage_id}
    end
    result
  end

  def self.non_mobility_ids
    @@non_mobility_ids ||= build_non_mobility_ids
  end

  def self.build_non_mobility_ids
    result = []
    SuperUsage.non_mobility.each do |super_usages|
      super_usages.usages.each {|super_usage| result << super_usage.usage_id}
    end
    result
  end

  def self.reset
    @@mobility_ids = nil
    @@non_mobility_ids = nil
  end
end
