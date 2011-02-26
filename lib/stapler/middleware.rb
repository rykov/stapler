require 'rack/utils'
require 'rack/file'

module Stapler
  class Middleware
    def initialize(app, opts = {})
      @app = app
      @config = Stapler::Config.new(opts)
      @path_regex = @config.path_regex
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
      assets = Stapler::Asset.new(@config, asset_path)
      response = assets.response(env)

      if response[0] == 200
        # Pull out the body
        body = response[2]
        body = File.read(body.path) if body.is_a?(Rack::File)

        # Compress the body and update response
        if @config.perform_compress
          body = compress(body, asset_path)
          response[1]['Content-Length'] = Rack::Utils.bytesize(body).to_s
          response[2] = body
        end

        # Save the compressed response for future calls
        save_response(asset_path, body) if @config.perform_caching
      end

      response
    end

    def compress(content, path)
      # Compress using the path as an indicator for format
      if path =~ /\.css$/
        YUICompressor.compress_css(content)
      elsif path =~ /\.js$/
        YUICompressor.compress_js(content, :munge => true)
      else
        content
      end
    end

    def save_response(asset_path, content)
      path = File.expand_path(asset_path, @config.cache_dir)
      return unless path =~ /^#{@config.cache_dir}/

      # Ensure directory is present
      dir  = File.dirname(path)
      FileUtils.mkdir_p(dir) unless File.exists?(dir)

      # Write response
      File.open(path, 'w') { |f| f.write(content) }
    end
  end
end