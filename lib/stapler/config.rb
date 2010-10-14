#--
# Copyright (c) 2009 Michael Rykov
#
# TODO: Make path selectors configurable
#++

module Stapler
  module Config
    PREFIX = 'stapler'
    WHITELIST_DIR = %w(javascripts stylesheets)
    WHITELIST_RE = [
      %r{^/javascripts/.*\.js[$\?]},
      %r{^/stylesheets/.*\.css[$\?]}
    ]

    class << self
      def stapleable_path?(source)
        WHITELIST_RE.any? { |re| source =~ re }
      end

      def stapleable_dir?(dir)
        WHITELIST_DIR.include?(dir)
      end
    end
  end
end