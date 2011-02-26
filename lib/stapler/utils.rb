#--
# Copyright (c) Michael Rykov
#++

module Stapler
  class Utils
    class << self
      def response_body(response)
        body = response[2]
        body.is_a?(Rack::File) ? File.read(body.path) : body
      end
    end
  end
end