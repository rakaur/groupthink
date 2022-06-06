class StreamsController < ApplicationController
  before_action :set_stream, only: %i[ show edit update destroy ]
  before_action :set_thoughts, only: %i[ edit update ]

  # GET /streams or /streams.json
  def index
    # Load the default Stream followed by Streams the current user owns
    @streams = Stream.where(id: 1)
    @streams = @streams.or(Stream.where(id: current_user.streams.limit(2))) if user_signed_in?
    @streams = @streams.limit(3).order(id: :asc)

    # Since the `Stream#thoughts` method only looks like a real association
    # but really isn't and has no caching, we pre-load all of the Users from
    # all of the Thoughts from all of the Streams and pass it down the render
    # chain into the partials
    @thoughts = {}
    @streams.each do |stream|
      @thoughts[stream.hash] = stream.thoughts(10).includes(:user).load
    end
  end

  # GET /streams/1 or /streams/1.json
  def show
    respond_to do |format|
      format.html { redirect_to streams_url }
      format.json
    end
  end

  # GET /streams/new
  def new
    @stream = Stream.new
  end

  # GET /streams/1/edit
  def edit
  end

  # TODO :reek:TooManyStatements
  #
  # POST /streams or /streams.json
  def create
    @stream = Stream.new(stream_params)

    respond_to do |format|
      if @stream.save
        format.html { redirect_to stream_url(@stream), notice: "Stream was successfully created." }
        format.json { render :show, status: :created, location: @stream }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @stream.errors, status: :unprocessable_entity }
      end
    end
  end

  # TODO :reek:TooManyStatements
  #
  # PATCH/PUT /streams/1 or /streams/1.json
  def update
    respond_to do |format|
      if @stream.update(stream_params)
        format.html { redirect_to edit_stream_url(@stream), notice: "stream saved" }
        format.json { render :show, status: :ok, location: @stream }
      else
        @stream.reload # Not sure why this is necessary but it keeps around the invalid values
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @stream.errors, status: :unprocessable_entity }
      end
    end
  end

  # TODO :reek:TooManyStatements
  #
  # DELETE /streams/1 or /streams/1.json
  def destroy
    @stream.destroy

    respond_to do |format|
      format.html { redirect_to streams_url, notice: "Stream was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_stream
      @stream = Stream.find(params[:id])
    end

    # Preload Thoughts to avoid additional queries
    # TODO remove limit and paginate
    def set_thoughts
      @thoughts = @stream.thoughts(10).includes(:user).load
    end

    # Only allow a list of trusted parameters through.
    def stream_params
      params.require(:stream).permit(%i[ all_tags any_tags author_ids content
                                         created created_ago created_range limit
                                         updated updated_ago updated_range ])
    end
end
