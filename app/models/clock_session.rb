class ClockSession < ApplicationRecord
  belongs_to :user

  def self.formatted_est_datetime(datetime)
    return unless datetime
    datetime.in_time_zone("Eastern Time (US & Canada)").to_formatted_s(:long_ordinal) + " EST"
  end
end
