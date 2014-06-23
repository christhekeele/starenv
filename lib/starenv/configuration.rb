require 'logger'

require 'block_party'

module Starenv
  class Configuration < BlockParty::Configuration

    attr_accessor :logger, :pattern, :verbose, :bundle
    
    def initialize
      @logger  = Logger.new $stdout
      @pattern = ".%s.env"
      @verbose = true
      @bundle  = false
    end

  end
end
