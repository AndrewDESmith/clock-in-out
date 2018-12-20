require 'test_helper'

class ClockSessionsControllerTest < ActionDispatch::IntegrationTest
  should "not allow a user to clock in if they did not clock out of their last clock session" do
    # Trigger new action for the last_clock_session, whose fixture lacks a clock out time.
    get "/clock_sessions/new"
    assert_response :redirect
  end

  should "allow a user to see their total session time for a given date range" do
    user = users(:andrew)
    sign_in users(:andrew)
    get total_user_clock_sessions_path(user.id, { "begin" => {"year" => "1999", "month" => "11", "day" => "1"}, "end" => {"year" => "2019", "month" => "01", "day" => "01"} })
    assert_response :success
    session_time = user.total_user_session_time_for_date_range("1999-01-01", "2001-01-03")
    assert response.body.match(session_time)
  end
end
