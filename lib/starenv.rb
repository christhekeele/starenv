require 'forwardable'

require 'block_party'

require 'starenv/configuration'
require 'starenv/loader'

module Starenv
  
  extend BlockParty::Configurable
  configure_with Configuration

  extend SingleForwardable
  def_delegator :configuration, :logger
  
  class << self
    
    def load(*envs, &block)
      autoconfigure!
      Loader.new(envs, configuration, &block).call
    end

  private
  
    def autoconfigure!
      self.configure unless configuration
    end

  end
  
end

require 'starenv/version'
