#!/usr/local/bin/ruby -w


=begin
 OpenTok Ruby Library v0.90.0
 http://www.tokbox.com/

 Copyright 2010, TokBox, Inc.

 Date: November 05 14:50:00 2010
=end

require 'cgi'
require 'openssl'
require 'base64'
require 'uri'
require 'net/https'
require 'rexml/document'

DIGEST  = OpenSSL::Digest::Digest.new('sha1')

class Hash
  def urlencode
    to_a.map do |name_value|
      if name_value[1].is_a? Array
        name_value[0] = CGI.escape name_value[0].to_s
        name_value[1].map { |e| CGI.escape e.to_s }
        name_value[1] = name_value[1].join "&" + name_value[0] + "="
        name_value.join '='
      else
        name_value.map { |e| CGI.escape e.to_s }.join '='
      end
    end.join '&'
  end
end

module OpenTok

  class SessionPropertyConstants
    ECHOSUPPRESSION_ENABLED = "echoSuppression.enabled"; #Boolean
	MULTIPLEXER_NUMOUTPUTSTREAMS = "multiplexer.numOutputStreams"; #Integer
	MULTIPLEXER_SWITCHTYPE = "multiplexer.switchType"; #Integer
	MULTIPLEXER_SWITCHTIMEOUT = "multiplexer.switchTimeout"; #Integer
  end

  class Net::HTTP
    alias_method :old_initialize, :initialize
    def initialize(*args)
      old_initialize(*args)
      @ssl_context = OpenSSL::SSL::SSLContext.new
      @ssl_context.verify_mode = OpenSSL::SSL::VERIFY_NONE
    end
  end

  def self.included(base)
    # Initialize module.
  end

  class OpenTokSession
    attr_accessor :session_id

    def initialize(session_id)
      @session_id     = session_id
    end

    def to_s
      session_id
    end
  end

  class OpenTokSDK
    attr_writer :api_url
    @@TOKEN_SENTINEL = "T1=="
    @@SDK_VERSION = "tbruby-%s" % [ VERSION ]

    # @@API_URL = API_URL

    def initialize(partner_id, partner_secret)
      @api_url = API_URL
      @partner_id = partner_id
      @partner_secret = partner_secret
    end

    def generate_token(opts = {})
      {:session_id=>nil, :permissions=>[], :create_time=>nil, :expire_time=>nil}.merge!(opts)

      create_time = opts[:create_time].nil? ? Time.now  :  opts[:create_time]
      session_id = opts[:session_id].nil? ? '' : opts[:session_id]

      data_params = {
        :session_id => session_id,
        :create_time => create_time.to_i,
        :permissions => opts[:permissions],
        :nonce => rand
      }

      if not opts[:expire_time].nil?
        data_params[:expire_time] = opts[:expire_time].to_i
      end

      data_string = data_params.urlencode

      sig = sign_string(data_string, @partner_secret)
      meta_string = {
        :partner_id => @partner_id,
        :sdk_version => @@SDK_VERSION,
        :sig => sig
      }.urlencode

      @@TOKEN_SENTINEL + Base64.encode64(meta_string + ":" + data_string).gsub("\n","")
    end

    def create_session(location='', opts={})
      opts.merge!({:partner_id => @partner_id, :location=>location})
      doc = do_request("/session/create", opts)
      if not doc.get_elements('Errors').empty?
        raise OpenTokException.new doc.get_elements('Errors')[0].get_elements('error')[0].children.to_s
      end
      OpenTokSession.new(doc.root.get_elements('Session')[0].get_elements('session_id')[0].children[0].to_s)
    end

    protected

    def sign_string(data, secret)
      OpenSSL::HMAC.hexdigest(DIGEST, secret, data)
    end

    def do_request(api_url, params, token=nil)

      url = URI.parse(@api_url + api_url)
      if not params.empty?
        req = Net::HTTP::Post.new(url.path)
        req.set_form_data(params)
      else
        req = Net::HTTP::Get.new(url.path)
      end

      if not token.nil?
        req.add_field 'X-TB-TOKEN-AUTH', token
      else
        req.add_field 'X-TB-PARTNER-AUTH', "#{@partner_id}:#{@partner_secret}"
      end
      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = true if @api_url.start_with?("https")
      res = http.start {|http| http.request(req)}
      case res
      when Net::HTTPSuccess, Net::HTTPRedirection
        # OK
        doc = REXML::Document.new(res.read_body)
        return doc
      else
        res.error!
      end
    rescue Net::HTTPExceptions
      raise
      raise OpenTokException.new 'Unable to create fufill request: ' + $!
    rescue NoMethodError
      raise
      raise OpenTokException.new 'Unable to create a fufill request at this time: ' + $1
    end
  end
end
