#--
# Copyright (c) 2009 Michael Rykov
#++

$:.unshift File.dirname(__FILE__)

require 'yuicompressor'
require 'stapler/utils'
require 'stapler/asset'
require 'stapler/bundle'
require 'stapler/config'
require 'stapler/middleware'

if defined?(Rails)
  require 'stapler/rails'
end