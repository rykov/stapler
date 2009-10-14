#--
# Copyright (c) 2009 Michael Rykov
#++

$:.unshift File.dirname(__FILE__)

require 'stapler/compressor'
require 'stapler/helper'

::ActionView::Helpers.send(:include, Stapler::Helper)
