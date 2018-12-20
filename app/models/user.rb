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

    session_times = user_sessions.collect do |us|
      next unless (us.clock_out.present? && us.created_at.present?)
      us.clock_out - us.created_at
    end.compact

    total_session_time = session_times.inject { |sum, session_time| sum + session_time }

    if total_session_time
      format_time(total_session_time)
    else
      "No session times exist for the selected date range."
    end
  end

  def format_time(total_session_time)
    hours, remaining_seconds = total_session_time.divmod(3600)
    minutes, seconds = remaining_seconds.divmod(60)
    rounded_seconds = seconds.round(0)
    "#{hours} #{"hour".pluralize(hours)}, #{minutes} #{"minute".pluralize(minutes)}, #{rounded_seconds} #{"second".pluralize(rounded_seconds)}"
  end
end
