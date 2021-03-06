class EventsController < ApplicationController
  before_action :set_event, only: [:show, :edit, :update, :destroy, :favorite, :unfavorite, :upvote, :downvote ]
  before_action :logged_in_user, only: [:create, :destroy]
  before_action :can_post?, only: [:new]
  before_action :has_happened?, only: [:favorite, :upvote, :downvote]
  before_action :is_owner?, only: [:edit, :update, :destroy]


  # GET /events
  # GET /events.json
  def index
    @events = Event.all
    @events = @events.sort {|a,b| b.startdate <=> a.startdate }

    # Searching
    if params[:search]
      @events = @events.all.search(params[:search])
    end

    # Filtering
    if params[:sorting]
      if params[:sorting] == "yesterday"
        @events = Event.yesterday
      elsif params[:sorting] == "today"
        @events = Event.today
      elsif params[:sorting] == "tomorrow"
        @events = Event.tomorrow
      elsif params[:sorting] == "week"
        @events = Event.thisweek
      end
    end
  end

  # GET /events/1
  # GET /events/1.json
  def show
  end

  # GET /events/new
  def new
  end

  # GET /events/1/edit
  def edit
    if owner?(@event.user_id)
      @event
    else
      flash[:danger] = "Sorry, you can't edit someone else's stuff"
      redirect_to @event
    end
  end

  # POST /events
  # POST /events.json
  def create
    # flash[:success] = current_user[:id]
    @event = current_user.events.build(event_params)
    respond_to do |format|
      if @event.save
        format.html { redirect_to root_url }
        flash[:success] = 'Event was successfully created.'
        format.json { render :show, status: :created, location: @event }
      else
        format.html { render :new }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /events/1
  # PATCH/PUT /events/1.json
  def update
    respond_to do |format|
      if @event.update(event_params)
        format.html { redirect_to @event, notice: 'Event was successfully updated.' }
        format.json { render :show, status: :ok, location: @event }
      else
        format.html { render :edit }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /events/1
  # DELETE /events/1.json
  def destroy
    @event.destroy
    flash[:sucess] = 'Event was successfully destroyed.'
    respond_to do |format|
      format.html { redirect_to events_url }
      format.json { head :no_content }
    end
  end

  def upvote 
    # @event = Event.find(params[:id])
    @event.upvote_by current_user
    redirect_to :back
  end  

  def downvote
    # @event = Event.find(params[:id])
    @event.downvote_by current_user
    redirect_to :back
  end

  def favorite 
    @event.upsaved_by current_user
    current_user.save
    redirect_to :back
    flash[:success] = "favorited"
  end

  def unfavorite
    @event.unsave_by current_user
    current_user.save
    redirect_to :back
    flash[:success] = "unfavorited"
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_event
      @event = Event.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def event_params
      params.require(:event).permit(:user_id, :title, :location, :description, :startdate, :enddate, :link, :avatar, :user)
    end

    def can_post?
      if logged_in?
        @event = Event.new
      else
        flash[:danger] = "Nice try. You can't post unless you are logged in."
        redirect_to root_url
      end
    end

# => Doesn't let you favorite/like anything that is in the past
    def has_happened?
      @event = Event.find(params[:id])
      if @event.enddate < Time.now
        flash[:danger] = "That event has already ended. No point in doing that!"
        redirect_to @event
      end
    end

    def is_owner?
      @event = Event.find(params[:id])
      if !((current_user && @event.id == current_user.id) || current_user.admin == true)
        flash[:danger] = "You don't own this post! Don't go changing it!"
        redirect_to events_path
      end
    end

end
