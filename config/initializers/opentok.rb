# SUtalk Configuration Constants

# --------------------------------------------
# ---------------- OpenTok ------------------
# --------------------------------------------
              # TokBox Constants - Production
opentok = { 
          :api_key => 177891, 
          :api_secret => "fe79f53b71d2e7e4b89eafd06d1d45bd8adbb421",
          :api_url => "https://api.opentok.com/hl",
          :javascript_source => "http://static.opentok.com/v0.91/js/TB.min.js"
          }

              # TokBox Constants - Development
# opentok = { 
#           :api_key => 177891, 
#           :api_secret => "fe79f53b71d2e7e4b89eafd06d1d45bd8adbb421",
#           :api_url => 'https://staging.opentok.com/hl',
#           :javascript_source => "http://staging.tokbox.com/v0.91/js/TB.min.js"
#          }
Sutalk::Application.config.opentok_api = opentok

