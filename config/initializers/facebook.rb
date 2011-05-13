# SUtalk Configuration Constants

# --------------------------------------------
# ---------------- Facebook ------------------
# --------------------------------------------

             # Facebook Constants
             
             #  LIVE
# APP_NAME = "sutalks"
# APP_ID = "168684223172954"

              # DEVELOPMENT
APP_NAME = "sutalktest"
APP_ID = "185866364769116"



              # Facebook api permissions
FB_PERMISSIONS = "friends_online_presence"


AUTH_URL = "http://www.facebook.com/dialog/oauth?client_id=" + APP_ID + "&scope=" + FB_PERMISSIONS

              # set the hash values for the configuration values
facebook_api = { :app_name => APP_NAME,
                 :app_id => APP_ID,
                 :auth_url => AUTH_URL,
                 :canvas_page => "http://apps.facebook.com/#{APP_NAME}/"
               }

facebook_api[:auth_url] =  "http://www.facebook.com/dialog/oauth?client_id=#{facebook_api[:app_id]}&scope=#{FB_PERMISSIONS}"

facebook_api[:json] = "{ app_name: '#{facebook_api[:app_name]}', app_id: '#{facebook_api[:app_id]}', auth_url: '#{facebook_api[:auth_url]}', canvas_page: '#{facebook_api[:canvas_page]}' }"

            # make these configuration hash values available throughout the app
Sutalk::Application.config.facebook_api = facebook_api


