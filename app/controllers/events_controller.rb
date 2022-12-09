class EventsController < ApplicationController
    before_action :authenticate_user!, only: [:new, :create, :event_attendees] 

    def index
        @events = Event.all
    end

    def new
        @event = Event.new
    end

    def create
        @event = current_user.created_events.build(event_params)

        if @event.save
            redirect_to @event
        else
            render :new, status: :unprocessable_entity
        end
    end

    def show
        @event = Event.find(params[:id])
    end

    def event_attendees
        @user = current_user
        user = (params[:id])
        @event = Event.find(params[:id])
        if @event.attendees.include?(@user.id)
            redirect_to root_path
        else
            @event.attendees<<@user
            redirect_to event_path(@event)
        end
    end

    private

    def event_params
        params.require(:event).permit(:title, :location, :date)
    end

end
