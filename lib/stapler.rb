#--
# Copyright (c) 2009 Michael Rykov
#++

$:.unshift File.dirname(__FILE__)

require 'stapler/config'
require 'stapler/compressor'
require 'stapler/stapler'
require 'stapler/helper'

::ActionView::Helpers.send(:include, Stapler::Helper)
