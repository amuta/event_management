# frozen_string_literal: true

module EventFilterConcern
  extend ActiveSupport::Concern

  def filter(events)
    events = filter_by_user_id(events)
    events = filter_by_start_time(events)
    events = filter_by_end_time(events)
    events = filter_by_name(events)
    filter_by_location(events)
  end

  private

  def filter_by_user_id(events)
    return events unless params[:user_id].present?

    user_id = parse_integer(params[:user_id])
    user_id ? events.where(user_id:) : events
  end

  def filter_by_start_time(events)
    return events unless params[:start_time].present?

    start_time = parse_datetime(params[:start_time])
    start_time ? events.where('start_time >= ?', start_time) : events
  end

  def filter_by_end_time(events)
    return events unless params[:end_time].present?

    end_time = parse_datetime(params[:end_time])
    end_time ? events.where('end_time <= ?', end_time) : events
  end

  def filter_by_name(events)
    return events unless params[:name].present?

    name = sanitize_sql_like(params[:name])
    events.where('lower(name) LIKE lower(?)', "%#{name}%")
  end

  def filter_by_location(events)
    return events unless params[:location].present?

    location = sanitize_sql_like(params[:location])
    events.where('lower(location) LIKE lower(?)', "%#{location}%")
  end

  def parse_integer(int_str)
    Integer(int_str)
  rescue StandardError
    nil
  end

  def parse_datetime(datetime_str)
    DateTime.parse(datetime_str)
  rescue StandardError
    nil
  end

  def sanitize_sql_like(string)
    ActiveRecord::Base.sanitize_sql_like(string)
  end
end
