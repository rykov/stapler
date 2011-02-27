#--
# Copyright (c) Michael Rykov
#++
require 'rack/utils'
require 'rack/file'

module Stapler
  class Bundle
    def initialize(config, bundle)
      @config = config
      @paths = bundle_paths(bundle.to_s)
    end

    # Collect asset responses and build the collective response
    def response(env)
      if not @paths.is_a?(Array)
        @config.rack_file.not_found
      else
        @paths.inject([200, {}, '']) do |sum, path|
          # Fetch the response
          item = Stapler::Asset.new(@config, path).response(env)

          # Add the file title
          sum[2] << "\n\n\n/***** #{path} *****/\n\n\n"

          if item[0] != 200
            sum[2] << "/* [#{item[0]}] Asset problem */\n\n\n"
          else
            # Headers are merged
            sum[1].merge!(item[1])
            # Body is concatenated
            sum[2] << Stapler::Utils.response_body(item)
          end

          # Return the response
          sum
        end
      end
    end

  private
    def bundle_paths(bundle)
      # Ignore extension and asset id, etc
      key, signature = bundle.split(/[\.\/]/, 3)
      Utils.url_decode_with_signature(key, signature)
    rescue Utils::BadString
      nil
    end
  end
end