class AddNameToRooms < ActiveRecord::Migration
  def self.up
    add_column :rooms, :name, :string
    add_index :rooms, :name
  end

  def self.down
    remove_index :rooms, :name
    remove_column :rooms, :name
  end
end
