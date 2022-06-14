class GroupsController < ApplicationController
  before_action :set_group, only: %i[ show edit update destroy ]
  before_action :set_default_group, only: :index
  before_action :set_thoughts, only: %i[ index edit ]

  # GET /groups or /groups.json
  def index
  end

  # GET /groups/1 or /groups/1.json
  def show
    respond_to do |format|
      format.html { redirect_to groups_url }
      format.json
    end
  end

  # GET /groups/new
  def new
    @group = Group.new
  end

  # GET /groups/1/edit
  def edit
  end

  # TODO :reek:TooManyStatements
  #
  # POST /groups or /groups.json
  def create
    @group = Group.create(group_params)

    respond_to do |format|
      format.html { redirect_to group_url(@group), notice: "group was created" }
      format.json { render :show, status: :created, location: @group }
    end
  end

  # TODO :reek:TooManyStatements
  #
  # PATCH/PUT /groups/1 or /groups/1.json
  def update
    # respond_to do |format|
    #   if @group.update(group_params)
    #     format.html { redirect_to edit_group_url(@group), notice: "group was updated" }
    #     format.json { render :show, status: :ok, location: @group }
    #   else
    #     format.html { render :edit, status: :unprocessable_entity }
    #     format.json { render json: @group.errors, status: :unprocessable_entity }
    #   end
    # end
  end

  # TODO :reek:TooManyStatements
  #
  # DELETE /groups/1 or /groups/1.json
  def destroy
    @group.destroy

    respond_to do |format|
      format.html { redirect_to groups_url, notice: "group was destroyed" }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_group
      @group = Group.find(params[:id])
    end

    def set_default_group
      @group = user_signed_in? ? current_user.default_group : Group.find(1)
    end

    # Preload Thoughts to avoid additional queries
    # TODO remove limit and paginate
    def set_thoughts
      @thoughts = @group.thoughts.limit(10).includes(:user).load
    end

    # Only allow a list of trusted parameters through.
    def group_params
      params.require(:group).permit(:filter_id)
    end
end
