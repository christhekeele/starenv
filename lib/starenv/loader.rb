require 'forwardable'

require 'dotenv'

require 'starenv/environment'

module Starenv
  class Loader

    attr_reader :config
    
    extend Forwardable
    def_delegators :config, :pattern, :verbose, :logger
    
    def initialize(file_lookups, config, &callback)
      @file_lookups = file_lookups
      @config = config
      @callback = callback
    end
        
    
    def call
      Hash[ @file_lookups
        .lazy
        .map(&method(:require_bundle))
        .map(&method(:expand_file))
        .select(&method(:check_file))
        .map(&method(:load_file))
        .to_a
      ]
    end
    
  private
  
    def expand_file(lookup)
      case lookup
      when Symbol
        pattern % lookup.to_s
      when String
        if ENV[lookup]
          pattern % ENV[lookup]
        elsif File.exist?(lookup)
          lookup
        end
      end
    end
    
    def require_bundle(lookup)
      lookup.tap do |group|
        if defined?(Bundler) and config.bundle
          case group
          when Symbol
            Bundler.require group
          when String
            if ENV[group]
              Bundler.require ENV[group]
            end
          end
        end
      end
    end
    
    def check_file(filename)
      filename and File.exist? filename
    end
  
    def load_file(file)
      env = Environment.new(Dotenv.load file).tap do |env|
        env.log(logger) if env.applied? and config.verbose
        @callback.call(env) if @callback
      end
        
      [ file, env ]
    end
    
  end
end
