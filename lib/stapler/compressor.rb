#--
# Copyright (c) 2009 Michael Rykov
#++

require 'tempfile'

module Stapler
  class Compressor
    YUI_LIB = File.expand_path('../../ext/yuicompressor-2.4.2.jar', File.dirname(__FILE__))

    def initialize(original)
      @original_path = original
      @enabled = (original =~ /\.(js|css)$/)
    end
  
    def compress!
      return unless @enabled
      tempfile = Tempfile.new(File.basename(@original_path))
      if compress(@original_path, tempfile.path)
        FileUtils.cp(tempfile.path, @original_path)
        logger.info("[Stapler] Compressed #{@original_path}")
      end
    rescue => e
      logger.warn("[Stapler] Compression failure for #{@original_path}: #{e}")
    end
    
  protected 
    def compress(from, to)
      cmd = %Q|java -jar #{YUI_LIB} -o "#{to}" "#{from}"|
      logger.debug("[Stapler] Command: #{cmd}")
      system(cmd)
    end
    
    def logger
      Rails.logger
    end
  end
end

