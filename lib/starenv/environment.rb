require 'ostruct'

module Starenv
  class Environment < OpenStruct

    def applied
      @applied ||= to_h.select do |key, value|
        ENV[key.to_s] == value
      end
    end
    
    def applied?
      !applied.empty?
    end
    
    def ignored
      @ignored ||= to_h.reject do |key, value|
        ENV[key.to_s] == value
      end
    end
    
    def ignored?
      !ignored.empty?
    end
    
    def log(logger)
      longest = to_h.keys.group_by(&:size).max
      length = longest.nil? ? 0 : longest.first
      log_applied logger, length
      log_ignored logger, length
    end

  private

    def log_applied(logger, length)
      if applied?
        logger.info 'Applied variables:'
        applied.each do |key, value|
          logger.info format "  %-#{length}s => %s", key, value
        end
      end
    end

    def log_ignored(logger, length)
      if ignored?
        logger.info 'Ignored already set variables:'
        ignored.each do |key, value|
          logger.info format "  %-#{length}s => %s\n   %-#{length-1}s => %s", key, value, 'already', ENV[key.to_s]
        end
      end
    end
    
  end
end
