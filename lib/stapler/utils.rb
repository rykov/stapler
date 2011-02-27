#--
# Copyright (c) Michael Rykov
#
# Some methods copied from Dragonfly gem Serializer
#++

require 'base64'

module Stapler
  module Utils
    # Exceptions
    class BadString < RuntimeError; end

    class << self
      def response_body(response)
        body = response[2]
        body.is_a?(Rack::File) ? File.read(body.path) : body
      end

      def b64_encode(string)
        Base64.encode64(string).tr("\n=",'')
      end

      def b64_decode(string)
        padding_length = string.length % 4
        Base64.decode64(string + '=' * padding_length)
      end

      def marshal_encode(object)
        b64_encode(Marshal.dump(object))
      end

      def marshal_decode(string)
        Marshal.load(b64_decode(string))
      rescue TypeError, ArgumentError => e
        raise BadString, "couldn't decode #{string} - got #{e}"
      end
    end
  end
end