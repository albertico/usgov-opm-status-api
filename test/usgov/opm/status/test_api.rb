# frozen_string_literal: true

require "test_helper"

class USGov::OPM::Status::TestAPI < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::USGov::OPM::Status::API::VERSION
  end
end
