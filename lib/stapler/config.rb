#--
# Copyright (c) 2009 Michael Rykov
#
# TODO: Make path selectors configurable
#++

module Stapler
  module Config
    PREFIX = 'stapler'
    WHITELIST_DIR = %w(javascripts stylesheets)
    WHITELIST_RE = Regexp.union(
      %r{^/javascripts/.*\.js($|\?)},
      %r{^/stylesheets/.*\.css($|\?)}
    )

    STAPLIZE_RE = Regexp.union(
      %r{/javascripts/.*\.js($|\?)},
      %r{/stylesheets/.*\.css($|\?)}
    )

    class << self
      def stapleable_path?(source)
        source =~ WHITELIST_RE
      end

      def stapleable_dir?(dir)
        WHITELIST_DIR.include?(dir)
      end

      def staplize_url(url)
        url.gsub(STAPLIZE_RE, "/#{PREFIX}\\0")
      end
    end
  end
end