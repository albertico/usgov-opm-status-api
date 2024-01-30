# frozen_string_literal: true

require "test_helper"

class USGov::OPM::Status::API::TestClient < Minitest::Test
  def setup
    @client = USGov::OPM::Status::API::Client.new

    @stub_http_headers = {
      "Connection" => "close",
      "Host" => "www.opm.gov",
      "User-Agent" => "http.rb/5.1.1"
    }

    @status_types_api_response = "{\"OperatingStatusTypes\":[{}],\"TotalCount\":0,\"LastUpdate\":\"Today\"}"
  end

  def test_that_client_can_be_instantiated
    assert_kind_of(USGov::OPM::Status::API::Client, @client)
  end

  def test_that_can_get_current_status
    assert_raises(RuntimeError) do
      @client.get_current_status
    end
  end

  def test_that_can_get_status_types
    status_types = @client.get_status_types

    assert_kind_of(Array, status_types)

    status_types.each do |status|
      assert_kind_of(USGov::OPM::Status::API::StatusType, status)
    end
  end

  def test_that_get_status_types_returns_all_known_statuses
    statuses = @client.get_status_types

    statuses.each do |status_type|
      status = { status: status_type.status, id: status_type.id }
      assert(USGov::OPM::Status::API::StatusType::STATUSES.include?(status))
    end

    assert_equal(USGov::OPM::Status::API::StatusType::STATUSES.count, statuses.count)
  end

  def test_that_get_status_types_raises_error_if_params_not_hash
    assert_raises(USGov::OPM::Status::API::ClientError) do
      @client.get_status_types(params: "param_not_in_hash_but_string=1")
    end
  end

  def test_that_get_status_types_raises_http_error_if_api_response_not_successful
    # Stubbing HTTP.get to respond with an error status code.

    WebMock.enable!

    stub_request(:get, USGov::OPM::Status::API::V1::StatusTypesAPI::API_ENDPOINT)
      .with(headers: @stub_http_headers)
      .to_return(status: 500, body: "", headers: {})

    assert_raises(USGov::OPM::Status::API::HTTPError) do
      @client.get_status_types
    end

    WebMock.disable!
  end

  def test_that_get_status_types_raises_http_error_if_http_client_fails
    # Stubbing HTTP.get to raise a HTTP:Error.

    WebMock.enable!

    stub_request(:get, USGov::OPM::Status::API::V1::StatusTypesAPI::API_ENDPOINT)
      .with(headers: @stub_http_headers)
      .to_raise(HTTP::Error)

    assert_raises(USGov::OPM::Status::API::HTTPError) do
      @client.get_status_types
    end

    WebMock.disable!
  end

  def test_that_get_status_types_raises_error_if_json_parsing_fails # rubocop:disable Metrics/MethodLength
    # Stubbing HTTP.get to return a valid response body and a 200 status code.
    # Stubbing Oj.load to raise an Oj::ParserError and Oj::Error.

    WebMock.enable!

    stub_request(:get, USGov::OPM::Status::API::V1::StatusTypesAPI::API_ENDPOINT)
      .with(headers: @stub_http_headers)
      .to_return(status: 200, body: @status_types_api_response, headers: {})

    Oj.stubs(:load).raises(Oj::ParseError)

    assert_raises(USGov::OPM::Status::API::ResponseParsingError) do
      @client.get_status_types
    end

    Oj.stubs(:load).raises(Oj::Error)

    assert_raises(USGov::OPM::Status::API::ResponseParsingError) do
      @client.get_status_types
    end

    WebMock.disable!
  end

  def test_that_get_status_types_raises_error_if_json_response_mismatches
    # Stubbing HTTP.get to return an invalid response body and a 200 status code.

    WebMock.enable!

    stub_request(:get, USGov::OPM::Status::API::V1::StatusTypesAPI::API_ENDPOINT)
      .with(headers: @stub_http_headers)
      .to_return(status: 200, body: "{}", headers: {})

    assert_raises(USGov::OPM::Status::API::InvalidResponseFormatError) do
      @client.get_status_types
    end

    WebMock.disable!
  end

  def test_that_can_get_status_history
    assert_raises(RuntimeError) do
      @client.get_status_history
    end
  end
end
