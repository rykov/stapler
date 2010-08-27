#--
# Copyright (c) 2009 Michael Rykov
#++

module Stapler
  class Compressor
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
      out = File.open(from) do |from_file|
        if from =~ /\.css$/
          YUICompressor.compress_css(from_file)
        elsif from =~ /\.js$/
          YUICompressor.compress_js(from_file, :munge => true)
        else
          raise StandardError.new("Unrecognized file type")
        end
      end

      File.open(to, 'w') { |f| f.write(out) }
    end

    def logger
      Rails.logger
    end
  end
end

