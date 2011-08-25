class Usage < ActiveRecord::Base
  belongs_to :super_usage

  def self.all_except_mobilities
    @@all_except_mobilities ||= self.where(:super_usage_id => SuperUsage.all_except_mobilities_ids)
  end

  def self.all_except_mobilities_ids
    @@all_except_mobilities_ids ||= all_except_mobilities.collect{|u| u.id}
  end

  def self.reset
    @@all_except_mobilities = nil
    @@all_except_mobilities_ids = nil
  end
end
