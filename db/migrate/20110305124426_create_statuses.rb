class CreateStatuses < ActiveRecord::Migration
  def self.up
    create_table :statuses do |t|
      t.string :label

      t.timestamps
    end
    
    Status.create(:id => 1, :label => "Inactive")
    Status.create(:id => 2, :label => "Invite")
    Status.create(:id => 3, :label => "New Friends")
    Status.create(:id => 4, :label => "New Friends: Full")
  end

  def self.down
    drop_table :statuses
  end
end
