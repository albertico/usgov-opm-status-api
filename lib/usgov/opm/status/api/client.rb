# frozen_string_literal: true

require_relative "errors"

module USGov
  module OPM
    module Status
      module API
        # USGov::OPM::Status::API::Client
        class Client
          include Errable

          def initialize # rubocop:disable Metrics/MethodLength
            @current_status_api = API::V1::CurrentStatusAPI.new
            @status_types_api = API::V1::StatusTypesAPI.new
            @status_history_api = API::V1::StatusHistoryAPI.new

            ##################################################################################
            # TEMPORARY HACK TO REMOVE BUGGY STATUSES                                        #
            ##################################################################################
            @is_a_buggy_status = proc do |status|
              case status
              # OTHER_MESSAGE
              in Id: "30b9681e-252d-4a9a-9247-4ea209bd1f55", Name: "Custom Status Message", Icon: "Alert",
                 Abbreviation: "Other Message", IsDefault: false
                true
              # OPEN_OTHER
              in Id: "a306b527-b677-414f-9abe-da2120ae9ae8", Name: "Open", Icon: "Open",
                 Abbreviation: "Open", IsDefault: false
                true
              else
                false
              end
            end
            ##################################################################################
          end

          def get_current_status
            raise("Not implemented")
          end

          def get_status_types(params: {}) # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
            params ||= {}
            # Validate that params is a Hash and raise exception if otherwise.
            # Note that the actual content of the Hash is not validated.
            raise_client_error("Parameters expected to be a Hash") unless params.is_a?(Hash)

            # Make HTTP GET request to the Status Types API.
            http_response = @status_types_api.call

            # Raise exception if HTTP response was not 200 OK.
            raise_http_error_based_on_response_status_code(http_response.code)

            # Let's parse the JSON response containing the status types.
            json_response = Oj.load(http_response.body.to_s, symbol_keys: true)

            # Validating the general structure of the JSON response. Be aware that validation
            # of the OperatingStatusTypes entries is delegated to the StatusType class.
            json_response => {
              OperatingStatusTypes: [Hash, *], TotalCount: Integer, LastUpdate: String
            }

            ##########################################################################
            # TEMPORARY HACK TO REMOVE BUGGY STATUSES                                #
            ##########################################################################
            json_response[:OperatingStatusTypes].delete_if do |status|
              @is_a_buggy_status.call(status)
            end
            json_response[:TotalCount] = json_response[:OperatingStatusTypes].count
            ##########################################################################

            # Creating a StatusType instance for all the OperatingStatusTypes entries in the
            # JSON response. The JSON structure of each status entry will be validated when
            # initializing the StatusType object. and an InvalidResponseFormatError will be raised.
            status_types = []
            json_response[:OperatingStatusTypes].each do |status|
              status_types << StatusType.new(status)
            end

            # Returning array of status types.
            status_types
          # Capturing certain exceptions to raise gem specific errors.
          # Oj::Error -- Capturing JSON parsing errors and raising ResponseParsingError
          rescue Oj::Error => e
            raise_response_parsing_error(e.message)
          # NoMatchingPatternError -- Capturing pattern matching errors and raising InvalidResponseFormatError
          rescue NoMatchingPatternError => e
            raise_invalid_response_format_error(e.message)
          end

          def get_status_history
            raise("Not implemented")
          end
        end
      end
    end
  end
end
