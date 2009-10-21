#--
# Copyright (c) 2009 Michael Rykov
#
# TODO: Make path selectors configurable
#++

module Stapler
  module Config
    WHITELIST = [%r{^/javascripts/.*\.js$}, %r{^/stylesheets/.*\.css$}]

    def self.stapleable?(source)
      ActionController::Base.perform_caching && WHITELIST.any? { |re| source =~ re }
    end
  end
end