require 'test_helper'

class ClockSessionTest < ActiveSupport::TestCase
  context "clock session" do
    should "allow a user to clock in" do
      user = users(:andrew)
      clock_session = user.clock_sessions.create!
      assert clock_session.user.first_name = "Andrew"
      assert_nil clock_session.clock_out
    end

    should "allow a user to clock out" do
      clock_session = clock_sessions(:second_clock_session_for_andrew)
      assert clock_session.user.first_name = "Andrew"
      assert_nil clock_session.clock_out
      clock_session.update!(clock_out: Time.now)
      assert_not_nil clock_session.clock_out
    end
  end
end
