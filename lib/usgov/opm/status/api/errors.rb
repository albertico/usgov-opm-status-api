# frozen_string_literal: true

module USGov
  module OPM
    module Status
      module API
        class Error < StandardError; end

        class InvalidResponseFormatError < Error; end

        class InvalidStatusTypeFormatError < InvalidResponseFormatError; end

        class InvalidStatusTypeError < InvalidStatusTypeFormatError; end

        class ResponseParsingError < Error; end

        class HTTPError < Error; end

        class ClientError < HTTPError; end
        class ServerError < HTTPError; end

        # 400 - Bad Request
        class BadRequestError < ClientError; end
        # 401 - Unauthorized
        class UnauthorizedError < ClientError; end
        # 403 - Forbidden
        class ForbiddenError < ClientError; end
        # 404 - Not Found
        class NotFoundError < ClientError; end
        # 422 - Unprocessable Entity
        class UnprocessableEntityError < ClientError; end
        # 429 - Too Many Requests
        class TooManyRequestsError < ClientError; end

        # 500 - Internal Server Error
        class InternalServerError < ServerError; end

        # USGov::OPM::Status::API::Errable
        module Errable
          HTTP_CLIENT_ERRORS = {
            400 => BadRequestError,
            401 => UnauthorizedError,
            403 => ForbiddenError,
            404 => NotFoundError,
            422 => UnprocessableEntityError,
            429 => TooManyRequestsError
          }.freeze

          HTTP_SERVER_ERRORS = {
            500 => InternalServerError
          }.freeze

          protected

          def raise_invalid_response_format_error(error_message)
            raise(InvalidResponseFormatError, "Invalid response format: #{error_message}")
          end

          def raise_invalid_status_type_format_error(error_message)
            raise(InvalidStatusTypeFormatError, "Invalid status type format: #{error_message}")
          end

          def raise_invalid_status_type_error(error_message)
            raise(InvalidStatusTypeError, "Invalid status type: #{error_message}")
          end

          def raise_response_parsing_error(error_message)
            raise(ResponseParsingError, "Error parsing HTTP response: #{error_message}")
          end

          def raise_unexpected_http_error(error_message)
            raise(HTTPError, "Unexpected HTTP error: #{error_message}")
          end

          def raise_client_error(error_message, error = ClientError)
            # Set error to ClientError if error is nil or not a child of ClientError.
            error =
              if error.nil?
                ClientError
              else
                error.ancestors.include?(ClientError) ? error : ClientError
              end

            raise(error, "Client error: #{error_message}")
          end

          def raise_server_error(error_message, error = ServerError)
            # Set error to ServerError if error is nil or not a child of ServerError.
            error =
              if error.nil?
                ServerError
              else
                error.ancestors.include?(ServerError) ? error : ServerError
              end

            raise(error, "Server error: #{error_message}")
          end

          def raise_http_error_based_on_response_status_code(http_status_code) # rubocop:disable Metrics/MethodLength
            # Raise generic HTTPError if status code is not an Integer.
            raise_unexpected_http_error("Invalid status code") unless http_status_code.is_a?(Integer)

            # Do nothing if status code is 200 OK.
            return if http_status_code == 200

            error_message = "#{http_status_code} #{HTTP::Response::Status::REASONS[http_status_code]}"

            case http_status_code
            when *HTTP_CLIENT_ERRORS.keys
              raise_client_error(error_message, HTTP_CLIENT_ERRORS[http_status_code])
            when *HTTP_SERVER_ERRORS.keys
              raise_server_error(error_message, HTTP_SERVER_ERRORS[http_status_code])
            else
              raise_unexpected_http_error(error_message)
            end
          end
        end
      end
    end
  end
end
