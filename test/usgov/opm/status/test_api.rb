# frozen_string_literal: true

require "test_helper"

class USGov::OPM::Status::TestAPI < Minitest::Test
  def test_that_status_api_module_exist
    assert(defined?(USGov::OPM::Status::API))
  end

  def test_that_status_api_has_version_number
    refute_nil(USGov::OPM::Status::API::VERSION)
  end
end
