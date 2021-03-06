class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  before_action :verify_if_admin_and_redirect_with_error_message_if_not, only: [:index, :destroy]

  # GET /users
  # GET /users.json
  def index
    @users = User.all
    @users = @users.order(:name).page params[:pagina]
  end

  # GET /users/1
  # GET /users/1.json
  def show
    if current_user.is_admin?
      redirect_to users_path
    else
      redirect_to edit_user_path
    end
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
      if !logged_in?
        @user.admin = false
      end
      if @user.save
        success_message = "User was successfully created."
        if !logged_in?
          success_message += " Please login."
        end
        flash[:success] = success_message
        format.html {
          if !logged_in?
            redirect_to root_path
          else
            redirect_to users_path
          end
        }
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
      if user_params["change_password"] == "1"
        updated = @user.update(user_params.except(:change_password))
      else
        updated = @user.update_columns(name: user_params["name"], phone: user_params["phone"], email: user_params["email"], admin: user_params["admin"])
      end

      if updated
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
    # Remove for enable delete
    #@user.destroy
    #respond_to do |format|
    #  flash[:warning] = "User was successfully destroyed."
    #  format.html { redirect_to users_url }
    #  format.json { head :no_content }
    #end
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
        params.require(:user).permit(:name, :email, :phone, :password, :password_confirmation, :admin, :change_password)
      else
        params.require(:user).permit(:name, :email, :phone, :password, :password_confirmation, :change_password)
      end
    end
end
