ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'

require File.expand_path('../../config/environment', __FILE__)
require "minitest/spec"
require "minitest/reporters"
# Minitest::Reporters.use! [Minitest::Reporters::DefaultReporter.new(:color => true)]
Minitest::Reporters.use! [Minitest::Reporters::SpecReporter.new(:color => true)]

module AroundEachTest
  require 'shoulda/context'
end

class Minitest::Test
  include AroundEachTest
end

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
end
