module Bookings
  class Creator
    def initialize(owner:, params:)
      @owner = owner
      @params = params
    end

    def call
      validate_guest!
      event_type = find_event_type!
      starts_at = parse_start_at!
      checker = AvailabilityChecker.new(owner: owner, event_type: event_type, starts_at: starts_at)

      raise ApiError.new(status: 422, code: "VALIDATION_ERROR", message: "Selected startAt is not an available slot") unless checker.valid_slot?
      raise ApiError.new(status: :conflict, code: "CONFLICT", message: "Selected slot is already booked") if checker.booked?

      Booking.create!(
        event_type: event_type,
        guest_name: params.fetch(:guestName).to_s.strip,
        guest_email: params.fetch(:guestEmail).to_s.strip,
        starts_at: starts_at,
        ends_at: checker.ends_at
      )
    rescue ActiveRecord::RecordInvalid => e
      raise ApiError.new(status: 422, code: "VALIDATION_ERROR", message: e.record.errors.full_messages.to_sentence)
    end

    private

    attr_reader :owner, :params

    def validate_guest!
      if params[:guestName].blank? || params[:guestEmail].blank?
        raise ApiError.new(status: :bad_request, code: "BAD_REQUEST", message: "guestName and guestEmail are required")
      end

      if params[:guestName].to_s.strip.length > 60
        raise ApiError.new(status: 422, code: "VALIDATION_ERROR", message: "guestName must be 60 characters or less")
      end

      if params[:guestEmail].to_s.strip.length > 120
        raise ApiError.new(status: 422, code: "VALIDATION_ERROR", message: "guestEmail must be 120 characters or less")
      end

      return if params[:guestEmail].to_s.match?(URI::MailTo::EMAIL_REGEXP)

      raise ApiError.new(status: :bad_request, code: "BAD_REQUEST", message: "guestEmail must be a valid email")
    end

    def find_event_type!
      event_type = owner.event_types.find_by(slug: params[:eventTypeId])
      return event_type if event_type

      raise ApiError.new(status: :not_found, code: "NOT_FOUND", message: "Event type not found")
    end

    def parse_start_at!
      Time.iso8601(params.fetch(:startAt).to_s)
    rescue ArgumentError, KeyError
      raise ApiError.new(status: :bad_request, code: "BAD_REQUEST", message: "startAt must be a valid ISO 8601 date-time")
    end
  end
end
