#--
# Copyright (c) 2010 Michael Rykov
#++

module Stapler
  module Rails
    class << self
      def activate!
        ::ActionView::Base.send(:include, RailsHelper)
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
      def javascript_include_tag(*sources)
        options = sources.extract_options!.stringify_keys

        if options.delete('cache') || options.delete('concat')
          recursive = options.delete('recursive')
          paths = compute_javascript_paths(sources, recursive)
          javascript_src_tag(Utils.bundle_path(paths), options)
        else
          sources << options
          super(*sources)
        end
      end

      def stylesheet_link_tag(*sources)
        options = sources.extract_options!.stringify_keys

        if options.delete('cache') || options.delete('concat')
          recursive = options.delete('recursive')
          paths = compute_stylesheet_paths(sources, recursive)
          stylesheet_tag(Utils.bundle_path(paths), options)
        else
          sources << options
          super(*sources)
        end
      end

    private
      def compute_public_path(src, dir, ext = nil, include_host = true)
        staple = include_host && src !~ %r{^[-a-z]+://} && Config.stapleable_dir?(dir)
        path = super(src, dir, ext, include_host)
        staple ? Config.staplize_url(path) : path
      end
    end
  end
end