#--
# Copyright (c) Michael Rykov
#++

module Stapler
  class Asset
    FORBIDDEN_PATHS = %w(.. WEB-INF META-INF)
    REWRITE_KEYS = %w(PATH_INFO REQUEST_PATH REQUEST_URI)

    def initialize(config, path)
      @config = config
      @path = path
    end

    def response(env)
      if forbidden?
        @config.rack_file.not_found
      else
        @config.rack_file.call(rewrite_env(env))
      end
    end

  private
    def forbidden?
      FORBIDDEN_PATHS.any? { |fp| @path.include?(fp) }
    end

    def rewrite_env(env)
      out = env.dup
      REWRITE_KEYS.each do |key|
        next unless out[key].is_a?(String)
        out[key] = out[key].gsub(@config.path_regex, "/\\1")
      end
      out
    end
  end
end