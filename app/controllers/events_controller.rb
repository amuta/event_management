class EventsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :show]
  before_action :set_event, only: [:show, :update, :destroy]
  before_action :authorize_user!, only: [:update, :destroy]

  # GET /events
  def index
    @events = Event.all.page(params[:page]).per(params[:per_page])
    
    render json: { events: @events.map(&:as_json), page: @events.current_page, total_pages: @events.total_pages }
  end

  # POST /events
  def create
    @event = current_user.events.build(event_params)
    if @event.save
      render json: @event.as_json, status: :created
    else
      render json: @event.errors, status: :unprocessable_entity
    end
  end

  # GET /events/:id
  def show
    render json: @event.as_json
  end

  # PUT /events/:id
  def update
    if @event.update(event_params)
      render json: @event.as_json
      render json: @event.errors, status: :unprocessable_entity
    end
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
    render json: { error: 'Event not found' }, status: :not_found
  end

  def event_params
    params.require(:event).permit(:name, :description, :location, :start_time, :end_time)
  end

  def authorize_user!
    render json: { error: 'Unauthorized' }, status: :unauthorized unless current_user.id == @event.user_id
  end
end
