require 'rack/utils'
require 'rack/file'

module Stapler
  class Middleware
    def initialize(app, opts = {})
      @app = app
      @config = Stapler::Config.new(opts)
    end

    def call(env)
      path_info = env["PATH_INFO"]

      if path_info =~ @config.bundle_regex
        _call_bundle(env, Rack::Utils.unescape($1))
      elsif path_info =~ @config.path_regex
        _call_asset(env, Rack::Utils.unescape($1))
      else
        @app.call(env)
      end
    end

  private
    def _call_bundle(env, path)
      bundle = Stapler::Bundle.new(@config, path)
      staple_response(bundle.response(env), "bundle/#{path}")
    end

    def _call_asset(env, path)
      assets = Stapler::Asset.new(@config, path)
      staple_response(assets.response(env), path)
    end

    def staple_response(response, asset_path)
      if response[0] == 200
        # Pull out the body
        body = Stapler::Utils.response_body(response)

        # Compress the body and update response
        body = compress(body, asset_path) if @config.perform_compress

        # Prepare the response and headers
        response[1]['Content-Length'] = Rack::Utils.bytesize(body).to_s
        response[2] = body

        # Add cache headers for Rack::Cache, etc
        response[1].merge!(cache_headers(asset_path))
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

    def cache_headers(path)
      duration = @config.perform_caching ? 31536000 : 0
      { "Cache-Control" => "public, max-age=#{duration.to_s}",
        "ETag" => %("#{Digest::SHA1.hexdigest(path)}") }
    end
  end
end