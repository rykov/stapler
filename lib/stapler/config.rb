#--
# Copyright (c) 2009 Michael Rykov
#
# TODO: Make path selectors configurable
#++

module Stapler
  class Config
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

    DEFAULT_ROOT = defined?(Rails) ? Rails.public_path : 'public'
    DEFAULT_PREFIX = 'stapler'

    attr_accessor :path_regex, :bundle_regex, :rack_file, :cache_dir,
                  :perform_caching, :perform_compress

    def initialize(opts = {})
      # The root directory of where all the public files are stored
      asset_dir    = opts[:public_path] || DEFAULT_ROOT

      # The path prefix and correcsponding RegEx for stapled assets
      path_prefix   = opts[:path_prefix] || DEFAULT_PREFIX
      @path_regex   = %r(^/#{path_prefix}/(.+)$)
      @bundle_regex = %r(^/#{path_prefix}/bundle/(.+)$)

      # Rack::File will pull all the source files
      @rack_file = Rack::File.new(asset_dir)

      # Should we write stapled results and where?
      @perform_caching = opts[:cache_assets] || false
      @cache_dir = File.join(asset_dir, path_prefix)

      # Should we compress stapled results
      @perform_compress = opts[:compress_assets] || false

      # Bundle URL signature secret
      @@secret = opts[:secret] || 'nakedemperor'
    end

    # FIXME: This should not be class variable
    def self.secret
      @@secret
    end
  end
end