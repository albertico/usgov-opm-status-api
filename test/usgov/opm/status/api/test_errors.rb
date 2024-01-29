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

  def test_that_errable_raises_http_error_if_status_code_not_integer
    assert_raises(USGov::OPM::Status::API::HTTPError) do
      @errable_obj.send(:raise_http_error_based_on_response_status_code, nil)
    end
  end

  def test_that_errable_raises_bad_request_error
    assert_raises(USGov::OPM::Status::API::BadRequestError) do
      @errable_obj.send(:raise_http_error_based_on_response_status_code, 400)
    end
  end

  def test_that_errable_raises_unauthorized_error
    assert_raises(USGov::OPM::Status::API::UnauthorizedError) do
      @errable_obj.send(:raise_http_error_based_on_response_status_code, 401)
    end
  end

  def test_that_errable_raises_forbidden_error
    assert_raises(USGov::OPM::Status::API::ForbiddenError) do
      @errable_obj.send(:raise_http_error_based_on_response_status_code, 403)
    end
  end

  def test_that_errable_raises_not_found_error
    assert_raises(USGov::OPM::Status::API::NotFoundError) do
      @errable_obj.send(:raise_http_error_based_on_response_status_code, 404)
    end
  end

  def test_that_errable_raises_unprocessable_entity_error
    assert_raises(USGov::OPM::Status::API::UnprocessableEntityError) do
      @errable_obj.send(:raise_http_error_based_on_response_status_code, 422)
    end
  end

  def test_that_errable_raises_too_many_requests_error
    assert_raises(USGov::OPM::Status::API::TooManyRequestsError) do
      @errable_obj.send(:raise_http_error_based_on_response_status_code, 429)
    end
  end

  def test_that_errable_raises_internal_server_error
    assert_raises(USGov::OPM::Status::API::InternalServerError) do
      @errable_obj.send(:raise_http_error_based_on_response_status_code, 500)
    end
  end
end
