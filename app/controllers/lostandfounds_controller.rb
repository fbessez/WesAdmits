class LostandfoundsController < ApplicationController
  before_action :set_lostandfound, only: [:show, :edit, :update, :destroy, :favorite, :unfavorite, :upvote, :downvote ]

  before_action :logged_in_user, only: [:create, :destroy]
  before_action :can_post?, only: [:new]
  before_action :is_owner?, only: [:edit, :update, :destroy]


  # GET /lostandfounds
  # GET /lostandfounds.json
  def index
    @lostandfounds = Lostandfound.all

    @lostandfounds = @lostandfounds.all.search(params[:search]) if params[:search]

    @lostandfounds = @lostandfounds.sort_by(&:foundtime) if params[:sorting] == "foundtime"
    @lostandfounds = @lostandfounds.where(lostorfound: true) if params[:sorting] == "lostonly"
    @lostandfounds = @lostandfounds.where(lostorfound: false)  if params[:sorting] == "foundonly"

  end

  # GET /lostandfounds/1
  # GET /lostandfounds/1.json
  def show
  end

  # GET /lostandfounds/new
  def new
    # can_post?
  end

  # GET /lostandfounds/1/edit
  def edit
    if owner?(@lostandfound.user_id)
      @lostandfound
    else
      flash[:danger] = "Sorry, you can't edit someone else's stuff"
      redirect_to @lostandfound
    end
  end

  # POST /lostandfounds
  # POST /lostandfounds.json
  def create
    @lostandfound = current_user.lostandfounds.build(lostandfound_params)
    respond_to do |format|
      if @lostandfound.save
        format.html { redirect_to root_url}
        flash[:success] = 'Lostandfound was successfully created.'
        format.json { render :show, status: :created, location: @lostandfound }
      else
        format.html { render :new }
        format.json { render json: @lostandfound.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /lostandfounds/1
  # PATCH/PUT /lostandfounds/1.json
  def update
    respond_to do |format|
      if @lostandfound.update(lostandfound_params)
        flash[:success] = 'Your post was successfully updated.'
        format.html { redirect_to root_path}
        format.json { render :show, status: :ok, location: @lostandfound }
      else
        format.html { render :edit }
        format.json { render json: @lostandfound.errors, status: :unprocessable_entity }
      end
    end
    # redirect_to root_path
  end

  # DELETE /lostandfounds/1
  # DELETE /lostandfounds/1.json
  def destroy
    @lostandfound.destroy
    flash[:sucess] = 'Lostandfound was successfully destroyed.'
    respond_to do |format|
      format.html { redirect_to lostandfounds_url }
      format.json { head :no_content }
    end
  end

  def upvote 
    # @event = Event.find(params[:id])
    @lostandfound.upvote_by current_user
    redirect_to :back
  end  

  def downvote
    # @event = Event.find(params[:id])
    @lostandfound.downvote_by current_user
    redirect_to :back
  end

  def favorite 
    @lostandfound.upsaved_by current_user
    current_user.save
    redirect_to :back
    flash[:success] = "Favorited"
  end

  def unfavorite
    @lostandfound.unsave_by current_user
    current_user.save
    redirect_to :back
    flash[:success] = "Unfavorited"
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_lostandfound
      @lostandfound = Lostandfound.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def lostandfound_params
      params.require(:lostandfound).permit(:title, :item, :foundlocation, :foundtime, :notes, :avatar, :lostorfound)
    end

    def can_post?
      if logged_in?
        @lostandfound = Lostandfound.new
      else
        flash[:danger] = "Nice try. You can't post unless you are logged in."
        redirect_to root_url
      end
    end

    def is_owner?
      @lostandfound = Lostandfound.find(params[:id])
      if !((current_user && @lostandfound.id == current_user.id) || current_user.admin == true)
        flash[:danger] = "You don't own this post! Don't go changing it!"
        redirect_to lostandfounds_path
      end
    end

end
