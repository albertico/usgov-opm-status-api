# frozen_string_literal: true

module USGov
  module OPM
    module Status
      module API
        class HTTPError < StandardError
        end

        class ClientError < HTTPError
        end

        class ServerError < HTTPError
        end
      end
    end
  end
end
