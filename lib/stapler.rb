#--
# Copyright (c) 2009 Michael Rykov
#++

$:.unshift File.dirname(__FILE__)

require 'yuicompressor'
require 'stapler/config'
require 'stapler/compressor'
require 'stapler/helper'
require 'stapler/middleware'

if defined?(::ActionView::Helpers)
  ::ActionView::Helpers.send(:include, Stapler::Helper)
end
