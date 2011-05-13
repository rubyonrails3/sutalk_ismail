class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.integer :facebook_id
      t.string :name
      t.string :first_name
      t.string :last_name
      t.string :link
      t.integer :gender_id
      t.string :locale
      t.integer :available_id
      t.integer :status_id

      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end
