#--
# Copyright (c) 2010 Michael Rykov
#++

module Stapler
  module Rails
    class << self
      def activate!
        ::ActionView::Helpers.send(:include, RailsHelper)
      end

      def asset_host_proc(image_host = nil)
        prefix = File.join('/', Config::PREFIX)
        if image_host
          Proc.new { |source|
            host = image_host
            host << prefix if Config.stapleable_path?(source)
            host
          }
        else
          Proc.new { |source, request|
            host = request.host_with_port
            host << prefix if Config.stapleable_path?(source)
            host
          }
        end
      end
    end

    module RailsHelper
      def self.included(base)
        base.send :alias_method_chain, :compute_public_path, :stapler
      end

    private
      def compute_public_path_with_stapler(src, dir, ext = nil, include_host = true)
        if include_host && Config.stapleable_dir?(dir)
          dir = File.join(Config::PREFIX, dir)
        end

        compute_public_path_without_stapler(src, dir, ext, include_host)
      end
    end
  end
end