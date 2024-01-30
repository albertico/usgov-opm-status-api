# frozen_string_literal: true

require "test_helper"

class USGov::OPM::Status::API::TestV1 < Minitest::Test # rubocop:disable Metrics/ClassLength
  def setup
    @current_status_api = USGov::OPM::Status::API::V1::CurrentStatusAPI.new
    @status_types_api = USGov::OPM::Status::API::V1::StatusTypesAPI.new
    @status_history_api = USGov::OPM::Status::API::V1::StatusHistoryAPI.new

    @stub_http_headers = {
      "Connection" => "close",
      "Host" => "www.opm.gov",
      "User-Agent" => "http.rb/5.1.1"
    }
  end

  def test_that_current_status_api_can_be_instantiated
    assert_kind_of(USGov::OPM::Status::API::V1::CurrentStatusAPI, @current_status_api)
  end

  def test_that_current_status_api_call_returns_http_response
    http_response = @current_status_api.call
    assert_kind_of(HTTP::Response, http_response)
  end

  def test_that_current_status_api_call_raises_error_if_params_not_hash
    assert_raises(USGov::OPM::Status::API::ClientError) do
      @current_status_api.call(params: "param_not_in_hash_but_string=1")
    end
  end

  def test_that_current_status_api_call_raises_http_error
    WebMock.enable!

    stub_request(:get, USGov::OPM::Status::API::V1::CurrentStatusAPI::API_ENDPOINT)
      .with(headers: @stub_http_headers)
      .to_raise(HTTP::Error)

    assert_raises(USGov::OPM::Status::API::HTTPError) do
      @current_status_api.call
    end

    WebMock.disable!
  end

  def test_current_status_api # rubocop:disable Metrics/MethodLength
    http_response = @current_status_api.call
    json_response = Oj.load(http_response.body.to_s, symbol_keys: true)

    # Check HTTP response status code.
    assert_equal(200, http_response.code)

    # Check JSON response.
    valid_json_response_format =
      case json_response
      in Id: Integer, Title: String, Location: String, StatusSummary: String, StatusWebPage: String,
        ShortStatusMessage: String, LongStatusMessage: String, ExtendedInformation: String,
        DateStatusPosted: String, CurrentDate: String, DateStatusComplete: nil, AppliesTo: String,
        Icon: String, StatusType: String, StatusTypeGuid: String, Url: String
        true
      else
        false
      end
    assert(valid_json_response_format)
  end

  def test_that_status_types_api_can_be_instantiated
    assert_kind_of(USGov::OPM::Status::API::V1::StatusTypesAPI, @status_types_api)
  end

  def test_that_status_types_api_call_returns_http_response
    http_response = @status_types_api.call
    assert_kind_of(HTTP::Response, http_response)
  end

  def test_that_status_types_api_call_raises_error_if_params_not_hash
    assert_raises(USGov::OPM::Status::API::ClientError) do
      @status_types_api.call(params: "param_not_in_hash_but_string=1")
    end
  end

  def test_that_status_types_api_call_raises_http_error
    WebMock.enable!

    stub_request(:get, USGov::OPM::Status::API::V1::StatusTypesAPI::API_ENDPOINT)
      .with(headers: @stub_http_headers)
      .to_raise(HTTP::Error)

    assert_raises(USGov::OPM::Status::API::HTTPError) do
      @status_types_api.call
    end

    WebMock.disable!
  end

  def test_status_types_api # rubocop:disable Metrics/MethodLength
    http_response = @status_types_api.call
    json_response = Oj.load(http_response.body.to_s, symbol_keys: true)

    # Check HTTP response status code.
    assert_equal(200, http_response.code)

    # Check JSON response.
    valid_json_response_format =
      case json_response
      in OperatingStatusTypes: [Hash, *], TotalCount: Integer, LastUpdate: String
        true
      else
        false
      end
    assert(valid_json_response_format)

    # Check JSON response for each status type.
    json_response[:OperatingStatusTypes].each do |status_type|
      valid_status_type_format =
        case status_type
        in Id: String, Name: String, Icon: String, Abbreviation: String, IsDefault: true | false
          true
        else
          false
        end
      assert(valid_status_type_format)
    end
  end

  def test_that_status_history_api_can_be_instantiated
    assert_kind_of(USGov::OPM::Status::API::V1::StatusHistoryAPI, @status_history_api)
  end

  def test_that_status_history_api_call_returns_http_response
    http_response = @status_history_api.call
    assert_kind_of(HTTP::Response, http_response)
  end

  def test_that_status_history_api_call_raises_error_if_params_not_hash
    assert_raises(USGov::OPM::Status::API::ClientError) do
      @status_history_api.call(params: "param_not_in_hash_but_string=1")
    end
  end

  def test_that_status_history_api_call_raises_http_error
    WebMock.enable!

    stub_request(:get, USGov::OPM::Status::API::V1::StatusHistoryAPI::API_ENDPOINT)
      .with(headers: @stub_http_headers)
      .to_raise(HTTP::Error)

    assert_raises(USGov::OPM::Status::API::HTTPError) do
      @status_history_api.call
    end

    WebMock.disable!
  end

  def test_status_history_api # rubocop:disable Metrics/MethodLength
    http_response = @status_history_api.call
    json_response = Oj.load(http_response.body.to_s, symbol_keys: true)

    # Check HTTP response status code.
    assert_equal(200, http_response.code)

    # Check JSON response.
    valid_json_response_format =
      case json_response
      in [Hash, *]
        true
      else
        false
      end
    assert(valid_json_response_format)

    # Check JSON response for each historical status.
    json_response.each do |historical_status|
      valid_historical_status_format =
        case historical_status
        in Id: Integer, Title: String, Location: String, StatusSummary: String, StatusWebPage: String,
          ShortStatusMessage: String, LongStatusMessage: String, ExtendedInformation: String,
          DateStatusPosted: String, CurrentDate: String, DateStatusComplete: String, AppliesTo: String,
          Icon: String, StatusType: String, StatusTypeGuid: String, Url: String
          true
        else
          false
        end
      assert(valid_historical_status_format)
    end
  end
end
