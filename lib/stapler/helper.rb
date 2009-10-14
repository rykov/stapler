#--
# Copyright (c) 2009 Michael Rykov
#++

module Stapler
  module Helper
    def self.included(base)
      base.send :alias_method_chain, :write_asset_file_contents, :compressor
    end

  private
    def write_asset_file_contents_with_compressor(joined_asset_path, asset_paths)
      output = write_asset_file_contents_without_compressor(joined_asset_path, asset_paths)
      Compressor.new(joined_asset_path).compress!
      output
    end
  end
end