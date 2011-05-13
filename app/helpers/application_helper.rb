module ApplicationHelper

  
  # Return a title on a per-page basis.
  def title 
    base_title = "SUtalk: Friends Video Chat"
    # if @title.nil?
    #   base_title
    # else
    #   "#{base_title} | #{@title}"
    # end
  end
  
  def sutalkLink element_id
       text_field_tag "#{element_id}", sutalkUrl, 
                      :readonly => true, :class => "sutalkLink round"
  end
  
  def sutalkUrl 
    facebook_api = Sutalk::Application.config.facebook_api
    "#{facebook_api[:canvas_page]}?sid=#{@opentok_session[:sessionId]}"
  end
  
  def logo
    image_tag("logo.png", :alt => "SUtalk", :class => "round", :id => "logo")
  end
  
end
