#--
# Copyright (c) 2009 Michael Rykov
#
# TODO: Make path selectors configurable
#++

module Stapler
  module Config
    WHITELIST = [%r{^/javascripts/.*\.js$}, %r{^/stylesheets/.*\.css$}]
    PREFIX = "/stapler"

    class << self
      def stapleable?(source)
        ActionController::Base.perform_caching &&
        WHITELIST.any? { |re| source =~ re }
      end

      def stapled_path(source)
        File.join(PREFIX, source)
      end
    end
  end
end