module Serializers
  class BookingSerializer
    def self.call(booking)
      {
        id: booking.id.to_s,
        eventTypeId: booking.event_type.slug,
        eventTypeTitle: booking.event_type.title,
        guestName: booking.guest_name,
        guestEmail: booking.guest_email,
        startsAt: booking.starts_at.iso8601,
        endsAt: booking.ends_at.iso8601,
        createdAt: booking.created_at.iso8601
      }
    end
  end
end
