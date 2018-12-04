class CreateClockSessionsTable < ActiveRecord::Migration[5.2]
  def change
    create_table :clock_sessions do |t|
      t.datetime :clock_out
      t.datetime :created_at
      t.datetime :updated_at
    end

    add_index :clock_sessions, :clock_out
  end
end
