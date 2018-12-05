require 'test_helper'

class ClockSessionsControllerTest < ActionDispatch::IntegrationTest
  should "not allow a user to clock in if they did not clock out of their last clock session" do
    # Trigger new action for the last_clock_session, whose fixture lacks a clock out time.
    get "/clock_sessions/new"
    assert_response :redirect
  end
end
