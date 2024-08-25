# frozen_string_literal: true

class EventsController < ApplicationController
  include EventFilterConcern

  skip_before_action :authenticate_user!, only: %i[index show]
  before_action :set_event, only: %i[show update destroy]
  before_action :authorize_update!, only: [:update]
  before_action :authorize_destroy!, only: [:destroy]

  # GET /events
  def index
    @events = filter(Event.all).order(start_time: :desc).page(params[:page]).per(params[:per_page])

    render json: { events: @events.map(&:as_json), page: @events.current_page, total_pages: @events.total_pages }
  end

  # POST /events
  def create
    @event = current_user.events.build(event_params)
    if @event.save
      render json: @event.as_json, status: :created
      return
    end

    render_errors(@event, status: :unprocessable_entity)
  end

  # GET /events/:id
  def show
    render json: @event.as_json
  end

  # PUT /events/:id
  def update
    if @event.update(event_params)
      render json: @event.as_json
      return
    end

    render_errors(@event, status: :unprocessable_entity)
  end

  # DELETE /events/:id
  def destroy
    @event.destroy
    head :no_content
  end

  private

  def set_event
    @event = Event.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render_errors('Event not found', status: :not_found)
  end

  def event_params
    params.require(:event).permit(:name, :description, :location, :start_time, :end_time)
  end

  def authorize_update!
    return if user_allowed?('__update_any_event__')
    return if event_belongs_to_user?(@event)

    render_errors('Only the user who created the event can update it', status: :unauthorized)
  end

  def authorize_destroy!
    return if user_allowed?('__delete_any_event__')
    return if event_belongs_to_user?(@event)

    render_errors('Only the user who created the event can delete it', status: :unauthorized)
  end

  def event_belongs_to_user?(event)
    current_user.id == event.user_id
  end
end
