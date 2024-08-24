module EventFilterConcern
  extend ActiveSupport::Concern

  included do
    def filter(events)
      if params[:user_id].present?
        user_id = Integer(params[:user_id]) rescue nil
        events = events.where(user_id: user_id) if user_id
      end

      if params[:start_time].present?
        start_time = parse_datetime(params[:start_time])
        events = events.where('start_time >= ?', start_time) if start_time
      end

      if params[:end_time].present?
        end_time = parse_datetime(params[:end_time])
        events = events.where('end_time <= ?', end_time) if end_time
      end

      if params[:name].present?
        name = sanitize_sql_like(params[:name])
        events = events.where('lower(name) LIKE lower(?)', "%#{name}%")
      end

      if params[:location].present?
        location = sanitize_sql_like(params[:location])
        events = events.where('lower(location) LIKE lower(?)', "%#{location}%")
      end

      events
    end

    private

    def parse_datetime(datetime_str)
      DateTime.parse(datetime_str) rescue nil
    end

    def sanitize_sql_like(string)
      ActiveRecord::Base.sanitize_sql_like(string)
    end
  end
end
