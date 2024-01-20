# frozen_string_literal: true

require "test_helper"

class USGov::OPM::Status::API::TestErrors < Minitest::Test
  def test_that_http_error_class_exist
    assert defined?(USGov::OPM::Status::API::HTTPError)
  end

  def test_that_client_error_class_exist
    assert defined?(USGov::OPM::Status::API::ClientError)
  end

  def test_that_server_error_class_exist
    assert defined?(USGov::OPM::Status::API::ServerError)
  end
end
