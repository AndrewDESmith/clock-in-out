class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :clock_sessions

  def clock_sessions_from_date_range(beginning, ending=Date.today)
    beginning = beginning.in_time_zone
    ending = ending.in_time_zone
    clock_sessions.where(created_at: beginning..ending)
  end

  def total_user_session_time_for_date_range(beginning, ending=Date.today)
    user_sessions = clock_sessions_from_date_range(beginning, ending)
    session_times = user_sessions.collect { |us| us.clock_out - us.created_at }
    total_session_time = session_times.inject { |sum, session_time| sum + session_time }
    hours, remaining_seconds = total_session_time.divmod(3600)
    minutes, seconds = remaining_seconds.divmod(60)
    "#{hours} hours, #{minutes} minutes, #{seconds.round(0)} seconds"
  end
end
