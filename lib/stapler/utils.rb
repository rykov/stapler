#--
# Copyright (c) Michael Rykov
#
# Some methods copied from Dragonfly gem Serializer
#++

require 'base64'
require 'cgi'
require 'digest/sha1'

module Stapler
  module Utils
    # Exceptions
    class BadString < RuntimeError; end

    class << self
      def response_body(response)
        body = response[2]
        body.is_a?(Rack::File) ? File.read(body.path) : body
      end

      #### Base64 encoding for URLS ####
      def b64_encode(string)
        Base64.encode64(string).tr("\n=",'')
      end

      def b64_decode(string)
        padding_length = string.length % 4
        Base64.decode64(string + '=' * padding_length)
      end

      def url_encode(object)
        CGI.escape(b64_encode(Marshal.dump(object)))
      end

      def url_decode(string)
        Marshal.load(b64_decode(CGI.unescape(string)))
      rescue TypeError, ArgumentError => e
        raise BadString, "couldn't decode #{string} - got #{e}"
      end

      def groom_path(path)
        # Remove leading slashes and query params
        path.gsub(/^\//, '').gsub(/\?.*$/, '')
      end

      # Convert a list of assets into an URL
      # Note: Rails helpers adds the appropriate extension
      def bundle_path(assets)
        File.join('/stapler/bundle/', Bundle::Key.to_key(assets))
      end
    end
  end
end