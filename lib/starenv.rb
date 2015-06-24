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
    files.tsort.reduce(Environment.new(env)) do |environment, node|
      environment.apply files[node].load.environment
    end
  end

private

  def default_pattern
    'envs/%s.env'
  end

end
