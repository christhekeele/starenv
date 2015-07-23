require 'starenv/file/set'

module Starenv

  extend self

  def format(name)
    Kernel.format pattern, name
  end

  def pattern
    @@pattern ||= default_pattern
  end

  def pattern= string
    @@pattern = string.to_s
  end

  def files
    @@env_files ||= File::Set.new
  end

  def register(names, dependencies: [])
    Array(names).flatten.each do |name|
      files.add name, dependencies, block_given? ? Proc.new : nil
    end
  end

  def load(env = nil)
    files.tsort.reduce(Environment.new(env)) do |environment, name|
      node = files[name].load
      environment.apply(node.environment).tap do |environment|
        puts info node if node.loaded?
      end
    end
  end

private

  def default_pattern
    'envs/%s.env'
  end

  def info(node)
    longest = node.environment.variables.keys.group_by(&:size).max
    length = longest.nil? ? 0 : longest.first
    [
      Results.for(:applied).new(node.file.filename, node.environment.applied, length),
      Results.for(:ignored).new(node.file.filename, node.environment.ignored, length),
    ].map(&:to_s).compact.push("\n").join("\n")
  end

  class Results < Struct.new(:filename, :variables, :name_length)

    class << self
      def for(type)
        const_get type.to_s.capitalize
      end
    end

    def display
      formatted(variables).unshift(header).join("\n") unless variables.empty?
    end

    def to_s
      display or ''
    end

  private

    def formatted(variables)
      variables.map do |name, value|
        format_variable name, value
      end
    end

    class Applied < self

      def header
        "Applied variables from #{filename}:"
      end

      def format_variable(name, value)
        format "  %-#{name_length}s => %s", name, value
      end

    end

    class Ignored < self

      def header
        'Ignored already set variables:'
      end

      def format_variable(name, value)
        format "  %-#{name_length}s => %s (already %s)", name, value, ENV[name]
      end

    end

  end

end
