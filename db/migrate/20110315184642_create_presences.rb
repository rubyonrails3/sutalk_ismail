class CreatePresences < ActiveRecord::Migration
  def self.up
    create_table :presences do |t|
      t.integer :room_id
      t.integer :user_id

      t.timestamps
    end
  end

  def self.down
    drop_table :presences
  end
end
