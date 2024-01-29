# frozen_string_literal: true

require_relative "errors"

require "http"
require "oj"

module USGov
  module OPM
    module Status
      module API
        module V1
          BASE_URI = "https://www.opm.gov"

          # USGov::OPM::Status::API::V1::CurrentStatusAPI
          class CurrentStatusAPI
            include Errable

            API_ENDPOINT = "#{BASE_URI}/json/operatingstatus.json".freeze

            def call(params: {})
              params ||= {}
              raise_client_error("Parameters expected to be a Hash") unless params.is_a?(Hash)

              HTTP.get(API_ENDPOINT, params:)
            rescue HTTP::Error => e
              raise_unexpected_http_error(e.message)
            end
          end

          # USGov::OPM::Status::API::V1::StatusTypesAPI
          class StatusTypesAPI
            include Errable

            API_ENDPOINT = "#{BASE_URI}/json/statustypes.json".freeze

            def call(params: {})
              params ||= {}
              raise_client_error("Parameters expected to be a Hash") unless params.is_a?(Hash)

              HTTP.get(API_ENDPOINT, params:)
            rescue HTTP::Error => e
              raise_unexpected_http_error(e.message)
            end
          end

          # USGov::OPM::Status::API::V1::StatusHistoryAPI
          class StatusHistoryAPI
            include Errable

            API_ENDPOINT = "#{BASE_URI}/json/operatingstatushistory.json".freeze

            def call(params: {})
              params ||= {}
              raise_client_error("Parameters expected to be a Hash") unless params.is_a?(Hash)

              HTTP.get(API_ENDPOINT, params:)
            rescue HTTP::Error => e
              raise_unexpected_http_error(e.message)
            end
          end
        end
      end
    end
  end
end
