#--
# Copyright (c) 2009 Michael Rykov
#++

module Stapler
  class Stapler

    def initialize
      @in_progress = {}
      @in_progress_guard = Mutex.new
    end

    def ready?(path)
      !@in_progress[path] && File.exists?(path)
    end

    def process(from, to)
      @in_progress_guard.synchronize do
        return if @in_progress[to]
        @in_progress[to] = true
      end

      Thread.new { self.compress(from, to) }
    end

  protected
    def compress(from, to)
      FileUtils.mkdir_p(File.dirname(to))
      Compressor.new(from, to).compress!
      @in_progress.delete(to)
    end
  end
end
