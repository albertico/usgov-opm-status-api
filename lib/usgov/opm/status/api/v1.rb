# frozen_string_literal: true

require "http"
require "oj"

module USGov
  module OPM
    module Status
      module API
        module V1
          BASE_URI = "https://www.opm.gov"

          class CurrentStatus
            API_ENDPOINT = "#{BASE_URI}/json/operatingstatus.json"

            def call(params={})
              HTTP.get(API_ENDPOINT, params: params)
            end
          end

          class StatusTypes
            API_ENDPOINT = "#{BASE_URI}/json/statustypes.json"

            def call(params={})
              HTTP.get(API_ENDPOINT, params: params)
            end
          end

          class StatusHistory
            API_ENDPOINT = "#{BASE_URI}/json/operatingstatushistory.json"

            def call(params={})
              HTTP.get(API_ENDPOINT, params: params)
            end
          end
        end
      end
    end
  end
end
