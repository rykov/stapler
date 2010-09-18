#--
# Copyright (c) 2009 Michael Rykov
#++

module Stapler
  module Helper
    def self.included(base)
      base.send :alias_method_chain, :rewrite_asset_path, :stapler
    end

  private
    def rewrite_asset_path_with_stapler(source)
      if Config.stapleable?(source)
        source = Config.stapled_path(source)
      end

      rewrite_asset_path_without_stapler(source)
    end
  end
end