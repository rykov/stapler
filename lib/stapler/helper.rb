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
      if Config.stapleable?(source)
        @@stapler ||= Stapler.new
        stapled_source = "#{StaplerRoot}#{source}"
        stapled_path = asset_file_path(stapled_source)

        if @@stapler.ready?(stapled_path)
          source = stapled_source
        else
          @@stapler.process(asset_file_path(source), stapled_path)
        end
      end

      rewrite_asset_path_without_stapler(source)
    end

    #def compute_asset_host_with_stapler(source)
    #  compute_asset_host_without_stapler(source)
    #end
  end
end