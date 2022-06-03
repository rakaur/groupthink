class StreamsController < ApplicationController
  before_action :set_stream, only: %i[ show edit update destroy ]

  # GET /streams or /streams.json
  def index
    @streams = current_user.streams if user_signed_in?
    @streams ||= Stream.where(id: Stream.first.id)
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

    # Only allow a list of trusted parameters through.
    def stream_params
      params.require(:stream).permit(%i[ all_tags any_tags author_ids content
                                         created created_ago created_range limit
                                         updated updated_ago updated_range ])
    end
end
