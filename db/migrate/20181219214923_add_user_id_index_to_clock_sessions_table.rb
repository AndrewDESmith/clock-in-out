class AddUserIdIndexToClockSessionsTable < ActiveRecord::Migration[5.2]
  def change
    add_index :clock_sessions, :user_id
  end
end
