class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  before_action :verify_if_admin_and_redirect_with_error_message_if_not, only: [:index, :destroy]

  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end

  # GET /users/1
  # GET /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        flash[:success] = "User was successfully created. Please login."
        format.html { redirect_to root_path }
        format.json { render :show, status: :created, location: @user }
      else
        error_msgs = ""
        @user.errors.full_messages.each do |msg|
            error_msgs = "<li>#{msg}</li>"
        end
        flash.now[:danger] = "There was #{@user.errors.count.to_s} error(s): <br /> <ul>#{error_msgs}</ul>"
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        flash[:warning] = "User was successfully updated."
        format.html { redirect_to @user }
        format.json { render :show, status: :ok, location: @user }
      else
        error_msgs = ""
        @user.errors.full_messages.each do |msg|
            error_msgs = "<li>#{msg}</li>"
        end
        flash.now[:danger] = "There was #{@user.errors.count.to_s} error(s): <br /> <ul>#{error_msgs}</ul>"
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      flash[:warning] = "User was successfully destroyed."
      format.html { redirect_to users_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      # MR - If the user is not admin only can see their profile
      if current_user.is_admin?
        @user = User.find(params[:id])
      else
        @user = User.find(current_user.id)
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      # MR - If the user is not admin can't assign the admin flag
      if logged_in? && current_user.is_admin?
        params.require(:user).permit(:name, :email, :phone, :password, :password_confirmation, :admin)
      else
        params.require(:user).permit(:name, :email, :phone, :password, :password_confirmation)
      end
    end
end
