class SuperUsage < ActiveRecord::Base
  has_many :usages
  
  def self.all_except_mobilities 
    @@all_except_mobilities ||= self.where('name != ?', 'Mobilite')
  end
end
