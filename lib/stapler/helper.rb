#--
# Copyright (c) 2009 Michael Rykov
#++

module Stapler
  module Helper
    StaplerRoot = "/stapler"

    def self.included(base)
      base.send :alias_method_chain, :rewrite_asset_path, :stapler
      #base.send :alias_method_chain, :compute_asset_host, :stapler
    end

  private
    def rewrite_asset_path_with_stapler(source)
      unless ActionController::Base.perform_caching && source =~ /\.(js|css)$/
        rewrite_asset_path_without_stapler(source)

      else
        stapled_source = "#{StaplerRoot}#{source}"
        stapled_path = asset_file_path(stapled_source)

        unless File.exists?(stapled_path)
          FileUtils.mkdir_p(File.dirname(stapled_path))
          FileUtils.cp(asset_file_path(source), stapled_path)
          Compressor.new(stapled_path).compress!
        end

        rewrite_asset_path_without_stapler(stapled_source)
      end
    end

    #def compute_asset_host_with_stapler(source)
    #  compute_asset_host_without_stapler(source)
    #end
  end
end