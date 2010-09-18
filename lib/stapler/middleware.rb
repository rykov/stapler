require 'rack/utils'
require 'rack/file'

module Stapler
  class Middleware
    FORBIDDEN_PATHS = %w(.. WEB-INF)
    DEFAULT_ROOT = defined?(Rails) ? Rails.public_path : 'public'
    DEFAULT_PREFIX = 'stapler'

    def initialize(app, opts = {})
      @app = app
      @asset_dir = opts[:public_path] || DEFAULT_ROOT
      @rack_file = Rack::File.new(@asset_dir)

      @path_prefix = opts[:path_prefix] || DEFAULT_PREFIX
      @path_regex = %r(^/#{@path_prefix}/(.+)$)
    end

    def call(env)
      if env["PATH_INFO"] =~ @path_regex
        stapler_call(env, Rack::Utils.unescape($1))
      else
        @app.call(env)
      end
    end

  private
    def stapler_call(env, asset_path)
      response = @rack_file.dup
      return response.forbidden if forbidden_path?(asset_path)

      file_path = asset_file_path(asset_path)
      stapled_path = stapled_file_path(asset_path)

      if stapled_path && file_path && File.file?(file_path)
        Compressor.new(file_path, stapled_path).compress!
        response.path = stapled_path
        response.serving
      else
        response.not_found
      end
    end

    def asset_file_path(path)
      out = File.expand_path(path.split('?').first, @asset_dir)
      out =~ /^#{@asset_dir}/ ? out : nil
    end

    def stapled_file_path(path)
      asset_file_path(File.join(@path_prefix, path))
    end

    def forbidden_path?(path)
      FORBIDDEN_PATHS.any? { |fp| path.include?(fp) }
    end
  end
end