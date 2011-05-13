$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

=begin
 OpenTok Ruby Library v0.90.0
 http://www.tokbox.com/

 Copyright 2010, TokBox, Inc.

 Date: November 05 14:50:00 2010
=end


require 'rubygems'
require 'net/http'
require 'uri'
require 'digest/md5'
require 'cgi'
#require 'pp' # just for debugging purposes

Net::HTTP.version_1_2 # to make sure version 1.2 is used

module OpenTok
  VERSION = '0.90.0'
  # API_URL = "https://staging.tokbox.com/hl"
  
  API_URL = Sutalk::Application.config.opentok_api[:api_url]
  #Uncomment this line when you launch your app
  #API_URL = "https://api.opentok.com/hl";
end

require 'OpenTok/Exceptions'
require 'OpenTok/OpenTokSDK'
