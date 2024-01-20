# frozen_string_literal: true

require "test_helper"

class USGov::OPM::Status::API::TestV1 < Minitest::Test
  def setup
    @current_status_api = USGov::OPM::Status::API::V1::CurrentStatus.new
    @status_types_api = USGov::OPM::Status::API::V1::StatusTypes.new
    @status_history_api = USGov::OPM::Status::API::V1::StatusHistory.new
  end

  def test_current_status_api
    http_response = @current_status_api.call
    json_response = Oj.load(http_response.body.to_s, symbol_keys: true)

    assert_equal 200, http_response.code
    assert case(json_response)
    in Id: Integer, Title: String, Location: String, StatusSummary: String, StatusWebPage: String,
       ShortStatusMessage: String, LongStatusMessage: String, ExtendedInformation: String,
       DateStatusPosted: String, CurrentDate: String, DateStatusComplete: nil, AppliesTo: String,
       Icon: String, StatusType: String, StatusTypeGuid: String, Url: String
      true
    else
      false
    end
  end

  def test_status_types_api
    http_response = @status_types_api.call
    json_response = Oj.load(http_response.body.to_s, symbol_keys: true)

    # Check HTTP response code.
    assert_equal 200, http_response.code
    # Check JSON response structure.
    assert case(json_response)
    in OperatingStatusTypes: [Hash, *], TotalCount: Integer, LastUpdate: String
      true
    else
      false
    end
    # Check status types structure in JSON response.
    json_response[:OperatingStatusTypes].each do |status_type|
      assert case(status_type)
      in Id: String, Name: String, Icon: String, Abbreviation: String, IsDefault: true | false
        true
      else
        false
      end
    end
  end

  def test_status_history_api
    http_response = @status_history_api.call
    json_response = Oj.load(http_response.body.to_s, symbol_keys: true)

    # Check HTTP response code.
    assert_equal 200, http_response.code
    # Check JSON response structure.
    assert case(json_response)
    in [Hash, *]
      true
    else
      false
    end
    # Check historical status structure in JSON response.
    json_response.each do |historical_status|
      assert case(historical_status)
      in Id: Integer, Title: String, Location: String, StatusSummary: String, StatusWebPage: String,
         ShortStatusMessage: String, LongStatusMessage: String, ExtendedInformation: String,
         DateStatusPosted: String, CurrentDate: String, DateStatusComplete: String, AppliesTo: String,
         Icon: String, StatusType: String, StatusTypeGuid: String, Url: String
        true
      else
        false
      end
    end
  end
end
