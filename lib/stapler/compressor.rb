#--
# Copyright (c) 2009 Michael Rykov
#++

module Stapler
  class Compressor
    YUI_LIB = File.expand_path('../../ext/yuicompressor-2.4.2.jar', File.dirname(__FILE__))

    def initialize(from, to)
      @from_path = from
      @to_path = to
    end
  
    def compress!
      compress(@from_path, @to_path)
      logger.info("[Stapler] Compressed #{@from_path}")
    rescue => e
      logger.warn("[Stapler] Compression failure for #{@from_path}: #{e}")
      FileUtil.cp(@from_path, @to_path)
    end
    
  protected 
    def compress(from, to)
      cmd = %Q|java -jar #{YUI_LIB} -o "#{to}" "#{from}"|
      logger.debug("[Stapler] Command: #{cmd}")
      system(cmd) || raise(StandardError.new("Compression failure"))
    end
    
    def logger
      Rails.logger
    end
  end
end

