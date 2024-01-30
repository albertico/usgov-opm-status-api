# frozen_string_literal: true

require_relative "errors"

module USGov
  module OPM
    module Status
      module API
        # USGov::OPM::Status::API::StatusType
        class StatusType # rubocop:disable Metrics/ClassLength
          include Errable

          # Mapping known/valid statuses and their associated IDs to individual constants.
          OPEN =
            { status: :open,
              id: "e3e3d34b-05ae-451a-b13a-93a1ac92dfe4" }.freeze
          SHUTDOWN_FURLOUGH =
            { status: :shutdown_furlough,
              id: "30b9681e-252d-4a9a-9247-4ea209bd1f55" }.freeze
          # NOTE: OTHER_MESSAGE[:id] COLLIDES with SHUTDOWN_FURLOUGH[:id]
          # OTHER_MESSAGE =
          #   { status: :other_message,
          #     id: "30b9681e-252d-4a9a-9247-4ea209bd1f55" }.freeze
          PENDING_UPDATE =
            { status: :pending_update,
              id: "a306b527-b677-414f-9abe-da2120ae9ae8" }.freeze
          SHELTER_IN_PLACE =
            { status: :shelter_in_place,
              id: "673ab005-4beb-4754-bfba-74b2d8f19bbb" }.freeze
          CLOSED =
            { status: :closed,
              id: "210c3fb3-a6da-4674-8ba6-26e9ba15fed7" }.freeze
          IMMEDIATE_DEPARTURE =
            { status: :immediate_departure,
              id: "d003a973-4443-497f-b21a-76f32394c402" }.freeze
          EARLY_DEPARTURE_MANDATORY_TIME =
            { status: :early_departure_mandatory_time,
              id: "6074ff12-13a4-470e-890f-82daa4516d10" }.freeze
          EARLY_DEPARTURE =
            { status: :early_departure,
              id: "fb504d5c-79ab-4d33-a4af-b8969ac06599" }.freeze
          TIMED_DELAYED_ARRIVAL =
            { status: :timed_delayed_arrival,
              id: "5a95d24e-3b08-42fc-aafe-a4d7b640aec6" }.freeze
          DELAYED_ARRIVAL =
            { status: :delayed_arrival,
              id: "86cc1e55-aa95-4599-b3bb-1a001b58f861" }.freeze
          UNSCHEDULED_LEAVE_TELEWORK =
            { status: :unscheduled_leave_telework,
              id: "d67af175-e7f8-4c83-93c3-0b18f4046f02" }.freeze
          # NOTE: OPEN_OTHER[:id] COLLIDES with PENDING_UPDATE[:id]
          # OPEN_OTHER =
          #   { status: :open_other,
          #     id: "a306b527-b677-414f-9abe-da2120ae9ae8" }.freeze

          STATUSES =
            [
              OPEN,
              SHUTDOWN_FURLOUGH,
              # OTHER_MESSAGE,
              PENDING_UPDATE,
              SHELTER_IN_PLACE,
              CLOSED,
              IMMEDIATE_DEPARTURE,
              EARLY_DEPARTURE_MANDATORY_TIME,
              EARLY_DEPARTURE,
              TIMED_DELAYED_ARRIVAL,
              DELAYED_ARRIVAL,
              UNSCHEDULED_LEAVE_TELEWORK
              # OPEN_OTHER
            ].freeze

          STATUS_BY_ID =
            {
              OPEN[:id] => OPEN[:status],
              SHUTDOWN_FURLOUGH[:id] => SHUTDOWN_FURLOUGH[:status],
              # OTHER_MESSAGE[:id] => OTHER_MESSAGE[:status],
              PENDING_UPDATE[:id] => PENDING_UPDATE[:status],
              SHELTER_IN_PLACE[:id] => SHELTER_IN_PLACE[:status],
              CLOSED[:id] => CLOSED[:status],
              IMMEDIATE_DEPARTURE[:id] => IMMEDIATE_DEPARTURE[:status],
              EARLY_DEPARTURE_MANDATORY_TIME[:id] => EARLY_DEPARTURE_MANDATORY_TIME[:status],
              EARLY_DEPARTURE[:id] => EARLY_DEPARTURE[:status],
              TIMED_DELAYED_ARRIVAL[:id] => TIMED_DELAYED_ARRIVAL[:status],
              DELAYED_ARRIVAL[:id] => DELAYED_ARRIVAL[:status],
              UNSCHEDULED_LEAVE_TELEWORK[:id] => UNSCHEDULED_LEAVE_TELEWORK[:status]
              # OPEN_OTHER[:id] => OPEN_OTHER[:status]
            }.freeze

          ID_BY_STATUS =
            {
              OPEN[:status] => OPEN[:id],
              SHUTDOWN_FURLOUGH[:status] => SHUTDOWN_FURLOUGH[:id],
              # OTHER_MESSAGE[:status] => OTHER_MESSAGE[:id],
              PENDING_UPDATE[:status] => PENDING_UPDATE[:id],
              SHELTER_IN_PLACE[:status] => SHELTER_IN_PLACE[:id],
              CLOSED[:status] => CLOSED[:id],
              IMMEDIATE_DEPARTURE[:status] => IMMEDIATE_DEPARTURE[:id],
              EARLY_DEPARTURE_MANDATORY_TIME[:status] => EARLY_DEPARTURE_MANDATORY_TIME[:id],
              EARLY_DEPARTURE[:status] => EARLY_DEPARTURE[:id],
              TIMED_DELAYED_ARRIVAL[:status] => TIMED_DELAYED_ARRIVAL[:id],
              DELAYED_ARRIVAL[:status] => DELAYED_ARRIVAL[:id],
              UNSCHEDULED_LEAVE_TELEWORK[:status] => UNSCHEDULED_LEAVE_TELEWORK[:id]
              # OPEN_OTHER[:status] => OPEN_OTHER[:id]
            }.freeze

          attr_reader :id, :status, :name, :icon, :abbreviation, :is_default

          def initialize(status_type) # rubocop:disable Metrics/MethodLength
            raise(InvalidStatusTypeFormatError, "Status type cannot be nil") unless status_type
            raise(InvalidStatusTypeFormatError, "Status type must be a Hash") unless status_type.is_a?(Hash)

            unless status_type in Id: String, Name: String, Icon: String, Abbreviation: String, IsDefault: true | false
              raise(InvalidStatusTypeFormatError, "Invalid status type format: #{status_type}")
            end

            # Id
            @id = status_type[:Id]

            # Set status symbol based on Id and raise exception if Id is invalid/unknown.
            @status = StatusType.get_status_from_id(@id)
            raise(InvalidStatusTypeError, "Invalid status type ID: #{@id}") unless @status

            # Name
            @name = status_type[:Name]
            # Icon
            @icon = status_type[:Icon]
            # Abbreviation
            @abbreviation = status_type[:Abbreviation]
            # IsDefault
            @is_default = status_type[:IsDefault]
          end

          def to_h
            {
              id: @id,
              status: @status,
              name: @name,
              icon: @icon,
              abbreviation: @abbreviation,
              is_default: @is_default
            }
          end

          class << self
            def get_status_from_id(status_id)
              STATUS_BY_ID[status_id]
            end

            def get_id_from_status(status)
              ID_BY_STATUS[status]
            end
          end
        end
      end
    end
  end
end
