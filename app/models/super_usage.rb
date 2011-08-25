class SuperUsage < ActiveRecord::Base
  has_many :usages
  
  def self.all_except_mobilities 
    @@all_except_mobilities ||= self.where('name != ?', 'Mobilite')
  end

  def self.all_except_mobilities_ids
    @@all_except_mobilities_ids ||= all_except_mobilities.collect{|su| su.id}
  end

  def self.reset
    @@all_except_mobilities = nil
    @@all_except_mobilities_ids = nil
  end
end
