module Stapler
  class Middleware
    ASSETS_DIR = defined?(Rails.public_path) ? Rails.public_path : "public"

    def initialize(app)
      @app = app
    end

    def call(env)
      path = env['PATH_INFO']
      puts "LOOKING AT PATH #{path}"

      if path =~ %r(^/stapler/(.*)$)
        stapler_call(env, $1)
      else
        @app.call(env)
      end
    end

  private
    def stapler_call(env, path)
      file_path = asset_file_path(path)

      if File.file?(file_path)
        [200, {"Content-Type" => "text/plain"}, ['NOT DONE!']]
      else
        [404, {"Content-Type" => "text/html"}, ["Not Found!"]]
      end
    end

    def asset_file_path(path)
      File.join(ASSETS_DIR, path.split('?').first)
    end
  end
end