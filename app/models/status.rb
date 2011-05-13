# == Schema Information
# Schema version: 20110305124426
#
# Table name: statuses
#
#  id         :integer         not null, primary key
#  label      :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Status < ActiveRecord::Base
  has_many :rooms
end
