# frozen_string_literal: true

require "test_helper"

class USGov::OPM::Status::API::TestErrors < Minitest::Test # rubocop:disable Metrics/ClassLength
  def setup # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
    @error = USGov::OPM::Status::API::Error.new
    @invalid_response_format_error = USGov::OPM::Status::API::InvalidResponseFormatError.new
    @invalid_status_type_format_error = USGov::OPM::Status::API::InvalidStatusTypeFormatError.new
    @invalid_status_type_error = USGov::OPM::Status::API::InvalidStatusTypeError.new
    @response_parsing_error = USGov::OPM::Status::API::ResponseParsingError.new
    @http_error = USGov::OPM::Status::API::HTTPError.new
    @client_error = USGov::OPM::Status::API::ClientError.new
    @server_error = USGov::OPM::Status::API::ServerError.new
    @bad_request_error = USGov::OPM::Status::API::BadRequestError.new
    @unauthorized_error = USGov::OPM::Status::API::UnauthorizedError.new
    @forbidden_error = USGov::OPM::Status::API::ForbiddenError.new
    @not_found_error = USGov::OPM::Status::API::NotFoundError.new
    @unprocessable_entity_error = USGov::OPM::Status::API::UnprocessableEntityError.new
    @too_many_requests_error = USGov::OPM::Status::API::TooManyRequestsError.new
    @internal_server_error = USGov::OPM::Status::API::InternalServerError.new
    @errable_obj = Object.new
    @errable_obj.extend(USGov::OPM::Status::API::Errable)
  end

  def test_that_error_can_be_instantiated
    assert_kind_of(USGov::OPM::Status::API::Error, @error)
    assert_kind_of(StandardError, @error)
  end

  def test_that_invalid_response_format_error_can_be_instantiated
    assert_kind_of(USGov::OPM::Status::API::InvalidResponseFormatError, @invalid_response_format_error)
    assert_kind_of(USGov::OPM::Status::API::Error, @invalid_response_format_error)
  end

  def test_that_invalid_status_type_format_error_can_be_instantiated
    assert_kind_of(USGov::OPM::Status::API::InvalidStatusTypeFormatError, @invalid_status_type_format_error)
    assert_kind_of(USGov::OPM::Status::API::InvalidResponseFormatError, @invalid_status_type_format_error)
  end

  def test_that_invalid_status_type_error_can_be_instantiated
    assert_kind_of(USGov::OPM::Status::API::InvalidStatusTypeError, @invalid_status_type_error)
    assert_kind_of(USGov::OPM::Status::API::InvalidStatusTypeFormatError, @invalid_status_type_error)
  end

  def test_that_response_parsing_error_can_be_instantiated
    assert_kind_of(USGov::OPM::Status::API::ResponseParsingError, @response_parsing_error)
    assert_kind_of(USGov::OPM::Status::API::Error, @response_parsing_error)
  end

  def test_that_http_error_can_be_instantiated
    assert_kind_of(USGov::OPM::Status::API::HTTPError, @http_error)
    assert_kind_of(USGov::OPM::Status::API::Error, @http_error)
  end

  def test_that_client_error_can_be_instantiated
    assert_kind_of(USGov::OPM::Status::API::ClientError, @client_error)
    assert_kind_of(USGov::OPM::Status::API::HTTPError, @client_error)
  end

  def test_that_server_error_can_be_instantiated
    assert_kind_of(USGov::OPM::Status::API::ServerError, @server_error)
    assert_kind_of(USGov::OPM::Status::API::HTTPError, @server_error)
  end

  def test_that_bad_request_error_can_be_instantiated
    assert_kind_of(USGov::OPM::Status::API::BadRequestError, @bad_request_error)
    assert_kind_of(USGov::OPM::Status::API::ClientError, @bad_request_error)
  end

  def test_that_unauthorized_error_can_be_instantiated
    assert_kind_of(USGov::OPM::Status::API::UnauthorizedError, @unauthorized_error)
    assert_kind_of(USGov::OPM::Status::API::ClientError, @unauthorized_error)
  end

  def test_that_forbidden_error_can_be_instantiated
    assert_kind_of(USGov::OPM::Status::API::ForbiddenError, @forbidden_error)
    assert_kind_of(USGov::OPM::Status::API::ClientError, @forbidden_error)
  end

  def test_that_not_found_error_can_be_instantiated
    assert_kind_of(USGov::OPM::Status::API::NotFoundError, @not_found_error)
    assert_kind_of(USGov::OPM::Status::API::ClientError, @not_found_error)
  end

  def test_that_unprocessable_entity_error_can_be_instantiated
    assert_kind_of(USGov::OPM::Status::API::UnprocessableEntityError, @unprocessable_entity_error)
    assert_kind_of(USGov::OPM::Status::API::ClientError, @unprocessable_entity_error)
  end

  def test_that_too_many_requests_error_can_be_instantiated
    assert_kind_of(USGov::OPM::Status::API::TooManyRequestsError, @too_many_requests_error)
    assert_kind_of(USGov::OPM::Status::API::ClientError, @too_many_requests_error)
  end

  def test_that_internal_server_error_can_be_instantiated
    assert_kind_of(USGov::OPM::Status::API::InternalServerError, @internal_server_error)
    assert_kind_of(USGov::OPM::Status::API::ServerError, @internal_server_error)
  end

  def test_that_all_http_client_errors_are_a_client_error
    USGov::OPM::Status::API::Errable::HTTP_CLIENT_ERRORS.each_value do |specific_client_error|
      assert_includes(specific_client_error.ancestors, USGov::OPM::Status::API::ClientError)
    end
  end

  def test_that_all_http_server_errors_are_a_server_error
    USGov::OPM::Status::API::Errable::HTTP_SERVER_ERRORS.each_value do |specific_server_error|
      assert_includes(specific_server_error.ancestors, USGov::OPM::Status::API::ServerError)
    end
  end

  def test_that_errable_raises_invalid_response_format_error
    assert_raises(USGov::OPM::Status::API::InvalidResponseFormatError) do
      @errable_obj.send(:raise_invalid_response_format_error, "")
    end
  end

  def test_that_errable_raises_invalid_status_type_format_error
    assert_raises(USGov::OPM::Status::API::InvalidStatusTypeFormatError) do
      @errable_obj.send(:raise_invalid_status_type_format_error, "")
    end
  end

  def test_that_errable_raises_invalid_status_type_error
    assert_raises(USGov::OPM::Status::API::InvalidStatusTypeError) do
      @errable_obj.send(:raise_invalid_status_type_error, "")
    end
  end

  def test_that_errable_raises_unexpected_http_error
    assert_raises(USGov::OPM::Status::API::HTTPError) do
      @errable_obj.send(:raise_unexpected_http_error, "")
    end
  end

  def test_that_errable_raises_client_error
    assert_raises(USGov::OPM::Status::API::ClientError) do
      @errable_obj.send(:raise_client_error, "")
    end
  end

  def test_that_errable_raises_client_error_when_error_is_nil
    assert_raises(USGov::OPM::Status::API::ClientError) do
      @errable_obj.send(:raise_client_error, "", nil)
    end
  end

  def test_that_errable_raises_client_error_when_error_is_client_error
    assert_raises(USGov::OPM::Status::API::ClientError) do
      @errable_obj.send(:raise_client_error, "", USGov::OPM::Status::API::ClientError)
    end
  end

  def test_that_errable_raises_specific_client_error_defined_in_http_client_errors
    USGov::OPM::Status::API::Errable::HTTP_CLIENT_ERRORS.each_value do |specific_client_error|
      assert_raises(specific_client_error) do
        @errable_obj.send(:raise_client_error, "", specific_client_error)
      end
    end
  end

  def test_that_errable_raises_client_error_when_error_is_not_client_error
    assert_raises(USGov::OPM::Status::API::ClientError) do
      @errable_obj.send(:raise_client_error, "", USGov::OPM::Status::API::Error)
    end

    assert_raises(USGov::OPM::Status::API::ClientError) do
      @errable_obj.send(:raise_client_error, "", StandardError)
    end
  end

  def test_that_errable_raises_server_error
    assert_raises(USGov::OPM::Status::API::ServerError) do
      @errable_obj.send(:raise_server_error, "")
    end
  end

  def test_that_errable_raises_server_error_when_error_is_nil
    assert_raises(USGov::OPM::Status::API::ServerError) do
      @errable_obj.send(:raise_server_error, "", nil)
    end
  end

  def test_that_errable_raises_server_error_when_error_is_server_error
    assert_raises(USGov::OPM::Status::API::ServerError) do
      @errable_obj.send(:raise_server_error, "", USGov::OPM::Status::API::ServerError)
    end
  end

  def test_that_errable_raises_specific_server_error_defined_in_http_server_errors
    USGov::OPM::Status::API::Errable::HTTP_SERVER_ERRORS.each_value do |specific_server_error|
      assert_raises(specific_server_error) do
        @errable_obj.send(:raise_server_error, "", specific_server_error)
      end
    end
  end

  def test_that_errable_raises_server_error_when_error_is_not_server_error
    assert_raises(USGov::OPM::Status::API::ServerError) do
      @errable_obj.send(:raise_server_error, "", USGov::OPM::Status::API::Error)
    end

    assert_raises(USGov::OPM::Status::API::ServerError) do
      @errable_obj.send(:raise_server_error, "", StandardError)
    end
  end

  def test_that_errable_raises_http_error_if_status_code_not_integer
    assert_raises(USGov::OPM::Status::API::HTTPError) do
      @errable_obj.send(:raise_http_error_based_on_response_status_code, nil)
    end
  end

  def test_that_errable_raises_specific_client_error_based_on_status_code_defined_in_http_client_errors
    USGov::OPM::Status::API::Errable::HTTP_CLIENT_ERRORS.each do |status_code, specific_client_error|
      assert_raises(specific_client_error) do
        @errable_obj.send(:raise_http_error_based_on_response_status_code, status_code)
      end
    end
  end

  def test_that_errable_raises_specific_server_error_based_on_status_code_defined_in_http_server_errors
    USGov::OPM::Status::API::Errable::HTTP_SERVER_ERRORS.each do |status_code, specific_server_error|
      assert_raises(specific_server_error) do
        @errable_obj.send(:raise_http_error_based_on_response_status_code, status_code)
      end
    end
  end

  def test_that_errable_raises_http_error_if_status_code_not_supported
    # Unsupported HTTP status code: 418 - I'm a Teapot
    assert_raises(USGov::OPM::Status::API::HTTPError) do
      @errable_obj.send(:raise_http_error_based_on_response_status_code, 418)
    end

    # Integer that's not a real HTTP status code.
    assert_raises(USGov::OPM::Status::API::HTTPError) do
      @errable_obj.send(:raise_http_error_based_on_response_status_code, 600)
    end
  end
end
