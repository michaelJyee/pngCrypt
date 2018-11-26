class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: :destroy

  def index
    #3 columns currently, so make per_page % 3 == 0
    #ordered by image uploads
    @users = User.paginate(page: params[:page], :per_page => 24).order("ImageUploads DESC")
  end

  def show
    @user = User.find(params[:id])
  end
  
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      #log the user into the site on creation
      log_in @user
      flash[:success] = "Welcome to the pngCrypt!"
      #the following line redirects to the user profile
      #redirect_back_or @user
      #the following line redirects to the application page
      redirect_back_or root_path
    else
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new'
    end
  end

  def edit
  end

  def update
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end
  
  def destroy
    @user = User.find(params[:id])
    flash[:success] = @user.name+" deleted"
    @user.destroy
    redirect_to users_url
  end

  def reset
    @user = User.find(params[:id])
    @user.ImageUploads = 0
    @user.save
    flash[:success] = @user.name+" reset"
    redirect_to users_url
  end

  def promote
    @user = User.find(params[:id])
    @user.admin = true
    @user.save
    flash[:success] = @user.name+" now has admin access"
    redirect_to users_url
  end

  def demote
    @user = User.find(params[:id])
    @user.admin = false
    @user.save
    flash[:success] = @user.name+" no longer has admin access"
    redirect_to users_url
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :password,
                                  :password_confirmation)
    end

    # Confirms a logged-in user.
    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "You must be logged in to use this feature. Please login or make an account."
        redirect_to login_url
      end
    end

    # Confirms the correct user.
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end

    # Confirms an admin user.
    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
end