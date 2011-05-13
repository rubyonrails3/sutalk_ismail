# == Schema Information
# Schema version: 20110313210959
#
# Table name: users
#
#  id           :integer         not null, primary key
#  facebook_id  :integer
#  name         :string(255)
#  first_name   :string(255)
#  last_name    :string(255)
#  link         :string(255)
#  gender_id    :integer
#  locale       :string(255)
#  available_id :integer
#  status_id    :integer
#  created_at   :datetime
#  updated_at   :datetime
#

SEARCH_PARTNER_CYCLES = 4
SLEEP_SECONDS = 1

class User < ActiveRecord::Base

  has_many :presences
  has_many :rooms, :through => :presences
  

  def self.register fb
    fbUser = fb::facebook_user

    User.create!( :facebook_id => fbUser["id"].to_i, 
                  :name => fbUser["name"], 
                  :first_name => fbUser["first_name"], 
                  :last_name => fbUser["last_name"], 
                  :link => fbUser["link"], 
                  :gender_id => (fbUser["gender"] == "male"? 0 : 1), 
                  :locale => fbUser["locale"], 
                  :available_id => 0, 
                  :status_id => 0 
                )
  end
  
  # Get available user
  def self.getPartner( user )
    availableUsers = User.where( 
    "available_id = :available_id AND id != :id AND updated_at >= :updated_at", 
                                { :available_id => 1, 
                                  :id => user.id, 
                                  :updated_at => 1.minute.ago } )
    
    availableUsers.sample
  end
  
  # Search for an available partner.  Check that this user has not already been assigned during the search.
  def self.searchForPartner( user )
    partner = nil
    
    (0..SEARCH_PARTNER_CYCLES).each { |i| 
      return :preassigned if user.unavailable?
      partner = User.getPartner user
      break unless partner.nil?
      sleep SLEEP_SECONDS
    }
    partner
  end
  
  # Has this user already been registered
  def self.registered? fb
    User.find_by_facebook_id fb::facebook_user["id"]     
  end  

  def available
    self.update_attributes!( :available_id => 1 )
  end

  def unavailable
    self.update_attributes!( :available_id => 0 )
  end
  
  def unavailable?
    user = User.find(self.id)
    user.available_id == 0
  end

    
  # def self.getUser fb
  #   User.find_by_facebook_id fb::facebook_user["id"]     
  # end
end
