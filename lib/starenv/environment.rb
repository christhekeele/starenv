require 'delegate'

module Starenv
  class Environment

    attr_reader :variables, :applied, :ignored

    def initialize(source = nil)
      @source = source ? source : ENV
      @variables, @applied, @ignored = {}
    end

    def [] key
      @source[key].tap do |value|
        @variables[key] ||= Variable.new(key, value) if value
      end
    end

    def []= key, value
      @source.store(key, value.to_s).tap do |value|
        @variables[key] = Variable.new(key, value)
      end
    end

    def apply(hash)
      self.tap do |env|
        hash.each do |key, value|
          self[key] ||= value
        end
      end
    end

    def respond_to_missing?(method)
      @source.respond_to?(method) or super
    end

    def method_missing(method, *args)
      if @source.respond_to? method
        if block_given?
          @source.send method, *args, &Proc.new
        else
          @source.send method, *args
        end
      else
        super
      end
    end

  end
end
