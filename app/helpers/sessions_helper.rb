module SessionsHelper

#method to log in a user 
  def log_in(user)
    session[:user_id]=user.id
  end

#Remembers a user in a persistent session
  def remember(user)
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token]=user.remember_token
  end

#method to return current logged in user if any
  def current_user
   if(user_id = session[:user_id])
    @current_user ||= User.find_by(id: user_id)
   elsif (user_id=cookies.signed[:user_id])
    user=User.findby(id: user_id)
    if user && user.authenticated?(cookies[:remember_token])
      log_in user
      @current_user=user
    end
   end
  end

#checking if a user is logged in or not 
  def logged_in?
    !current_user.nil?
  end
#helper to forget a persistent session
  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end
#logging a user out of the site
 def log_out
   forget(current_user)
   session.delete(:user_id)
   @current_user=nil
 end
end
