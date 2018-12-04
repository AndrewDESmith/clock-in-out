class AddUserIdToClockSessionsTable < ActiveRecord::Migration[5.2]
  def self.up
    add_column :clock_sessions, :user_id, :integer
  end

  def self.down
    remove_column :clock_sessions, :user_id
  end
end
