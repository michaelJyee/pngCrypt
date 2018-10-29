class StaticPagesController < ApplicationController
  include SessionsHelper
  
  before_action :logged_in_user, only: [:stenApp]
  
  def home
    if logged_in?
      #create a var for the logged in user
      #lets us have access to username and id for application when logged in
      @userID = current_user.id
      @userName = current_user.name
      
      #puts @userID.to_s + ":" + @userName
    end
  end

  def help
  end
  
  def about
  end

  def contact
  end

  def stenApp
  
  end

  private
    # Confirms a logged-in user.
    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "You must be logged in to use this feature. Please login or make an account."
        redirect_to login_url
      end
    end
end
