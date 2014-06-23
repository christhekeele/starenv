require 'logger'

require 'block_party'

module Starenv
  class Configuration < BlockParty::Configuration

    attr_accessor :logger, :pattern, :verbose
    
    def initialize
      @logger  = Logger.new $stdout
      @pattern = ".env.%s"
      @verbose = true
    end

  end
end
