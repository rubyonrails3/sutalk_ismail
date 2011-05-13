require 'rubygems'
require 'facebook'

class ApplicationController < ActionController::Base
  protect_from_forgery
  
  protected

  # Login to facebook if user is not already logged in
  def facebook_login
    parameters = getParams params
    @fb = Facebook.new parameters

    session[:facebook_id] = @fb::facebook_user["id"] if !@fb::facebook_user.nil? 
        
    if @fb.loggedout?
                # Redirect to facebook login 
      render :facebooklogin, :layout => false
    elsif !User.registered? @fb
      User.register @fb
    end    
  end
  
  # Get Paramters for Facebook Access Token
  def getParams params
    
    if params[:signed_request]
      session[:parameters] = params
    else
      session[:parameters]
    end
  end  
end

