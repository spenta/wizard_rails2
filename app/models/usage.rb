class Usage < ActiveRecord::Base
  belongs_to :super_usage

  def self.all_except_mobilities
    @@all_except_mobilities ||= self.where(:super_usage_id => SuperUsage.all_except_mobilities_ids)
  end

  def self.all_except_mobilities_ids
    @@all_except_mobilities_ids ||= all_except_mobilities.collect{|u| u.id}
  end

  def self.all_mobilities
    mobility = SuperUsage.find_by_name('Mobilite')
    @@all_mobilities ||= self.where(:super_usage_id => mobility.id)
  end

  def self.all_mobilities_ids
    @@all_mobilities_ids ||= all_mobilities.collect{|m| m.id}
  end

  def self.reset
    @@all_except_mobilities = nil
    @@all_except_mobilities_ids = nil
    @@all_mobilities = nil
    @@all_mobilities_ids = nil
  end
end
