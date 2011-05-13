require 'spec_helper'

describe "LayoutLinks" do
  
  before(:each) do

    @params = {"signed_request"=>"Ug7oQzhRr3rFfLM7_O2QsSlYE7vDWzmqT8uNZ0Dd67E.eyJhbGdvcml0aG0iOiJITUFDLVNIQTI1NiIsImV4cGlyZXMiOjEyOTgzMTg0MDAsImlzc3VlZF9hdCI6MTI5ODMxNDQ2Nywib2F1dGhfdG9rZW4iOiIxODU4NjYzNjQ3NjkxMTZ8Mi5QMTVjNmJ3YWRnS3VGeDd0NVRwb013X18uMzYwMC4xMjk4MzE4NDAwLTIwNTYwMHxLaEpnRlFkZnVtR3ZVMG1ubnoxQzJNVmg3YzAiLCJ1c2VyIjp7ImNvdW50cnkiOiJ1cyIsImxvY2FsZSI6ImVuX1VTIiwiYWdlIjp7Im1pbiI6MjF9fSwidXNlcl9pZCI6IjIwNTYwMCJ9", "code"=>"2.zwQuB7bRTE4aQSjSb1K0PA__.3600.1296727200-205600|L8m2TCn9kenFuQJZ867bCvrEFIU"}
    
    

      
  end
  
  it "should a Home page at '/'" do
    get '/', @params
    response.should have_selector('title', :content => "Home")
  end
  
  it "should have a Invite page at '/invite'" do
    get '/invite'
    response.should have_selector('title', :content => "Invite")
  end
  
  # it "should have the right links on the layout" do
  #   params = @params
  #   visit root_path
  # end
end
