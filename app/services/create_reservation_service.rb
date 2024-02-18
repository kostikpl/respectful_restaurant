class CreateReservationService < BaseService
  RESERVATION_REQUIERD_HOURS_AHEAD = 2
  TOO_LATE_MSG = "Reservation can be done only #{RESERVATION_REQUIERD_HOURS_AHEAD} hours upfront"
  WRONG_TIMES_MSG = 'Start time should be greated than end time'
  OVERLAP_MSG = "Reservation can't be created at this time"

  class ToLateToReserveError < StandardError; end
  class WrongTimesError < StandardError; end
  class ReservationOverlapError < StandardError; end

  def initialize(params:)
    @params = params
    @starts_at = DateTime.parse(params[:starts_at].to_s)
    @ends_at = DateTime.parse(params[:ends_at].to_s)
  end

  def call
    # TODO: validate client exists
    # TODO: validate table exists
    # TODO: move validation logic to validator
    validate_date_ahead
    validate_ends_at_greated_than_starts_at
    validate_reservation_overlap
    create_reservation!
    Result.new(success: true, output: {}, status: 201)
  rescue ToLateToReserveError, WrongTimesError, ReservationOverlapError,ActiveRecord::NotNullViolation, ActiveRecord::RecordInvalid => e
    Result.new(success: false, error_msg: e.message, status: 400)
  end

  private

  def create_reservation!
    Reservation.create!(@params)
  end

  def validate_date_ahead
    if @starts_at < DateTime.now + 2.hours
      raise ToLateToReserveError.new(TOO_LATE_MSG)
    end
  end

  def validate_ends_at_greated_than_starts_at
    if @ends_at < @starts_at
      raise WrongTimesError.new(WRONG_TIMES_MSG)
    end
  end

  def validate_reservation_overlap
    overlap_exists =
      Reservation.where(
        '(starts_at < ? and ends_at > ?) or (starts_at < ? and ends_at > ?)',
        @starts_at, @starts_at, @ends_at, @ends_at
      ).exists?

    raise ReservationOverlapError.new(OVERLAP_MSG) if overlap_exists
  end
end
