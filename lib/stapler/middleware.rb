require 'rack/utils'
require 'rack/file'

module Stapler
  class Middleware
    FORBIDDEN_PATHS = %w(.. WEB-INF)
    REWRITE_KEYS = %w(PATH_INFO REQUEST_PATH REQUEST_URI)
    DEFAULT_ROOT = defined?(Rails) ? Rails.public_path : 'public'
    DEFAULT_PREFIX = 'stapler'

    def initialize(app, opts = {})
      @app = app

      # The root directory of where all the public files are stored
      asset_dir    = opts[:public_path] || DEFAULT_ROOT

      # The path prefix and correcsponding RegEx for stapled assets
      @path_prefix = opts[:path_prefix] || DEFAULT_PREFIX
      @path_regex  = %r(^/#{@path_prefix}/(.+)$)

      # Rack::File will pull all the source files
      @rack_file = Rack::File.new(asset_dir)

      # Should we write stapled results and where?
      @perform_caching = opts[:perform_caching] || false
      @cache_dir = File.join(asset_dir, @path_prefix)
    end

    def call(env)
      if env["PATH_INFO"] =~ @path_regex
        _call(env, Rack::Utils.unescape($1))
      else
        @app.call(env)
      end
    end

  private
    def _call(env, asset_path)
      return @rack_file.forbidden if forbidden_path?(asset_path)

      # Call Rack::File
      response = @rack_file.call(rewrite_env(env))

      if response[0] == 200
        # Compress the response body
        output = compress(response[2], asset_path)

        # Update response headers and body
        response[1]['Content-Length'] = Rack::Utils.bytesize(output).to_s
        response[2] = output

        # Save the compressed response for future calls
        save_response(asset_path, output) if @perform_caching
      end

      response
    end

    def compress(content, path)
      # Convert from Rack::File to String
      content = File.read(content.path) if content.is_a?(Rack::File)

      # Compress using the path as an indicator for format
      if path =~ /\.css$/
        YUICompressor.compress_css(content)
      elsif path =~ /\.js$/
        YUICompressor.compress_js(content, :munge => true)
      else
        content
      end
    end

    def rewrite_env(env)
      out = env.dup
      REWRITE_KEYS.each do |key|
        out[key] = out[key].gsub(@path_regex, "/\\1")
      end
      out
    end

    def forbidden_path?(path)
      FORBIDDEN_PATHS.any? { |fp| path.include?(fp) }
    end

    def save_response(asset_path, content)
      path = File.expand_path(asset_path, @cache_dir)
      return unless path =~ /^#{@cache_dir}/

      # Ensure directory is present
      dir  = File.dirname(path)
      FileUtils.mkdir_p(dir) unless File.exists?(dir)

      # Write response
      File.open(path, 'w') { |f| f.write(content) }
    end
  end
end