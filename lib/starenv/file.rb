require 'fileutils'
require 'pathname'

require 'starenv/file/parser'

module Starenv
  class File < ::File

    class << self

      def parse(name, *args)
        open name, *args, &:parse
      end

      def touch(name, *args)
        new(name, *args).touch(*args)
      end

    end

    attr_reader :name, :filename, :environment

    def initialize(name, mode = 'r', *args)
      @name = name
      @filename = Pathname.new Starenv.format @name
      super @filename, mode, *args
    end

    def parse
      tap do |file|
        unless parsed?
          @environment = Parser.new(each_line).call
        end
      end
    end

    def parsed?
      !!environment
    end

    def touch(*args)
      tap do |file|
        FileUtils.mkpath file.filename.dirname, *args
        FileUtils.touch  file.filename,         *args
      end
    end

  end
end

# class EnvFile < Struct.new(:name, :dependencies, :pattern, :hook)
#
#   def load
#     (hook || default_hook).call self do
#       Dotenv.load(filename).tap do |results|
#         puts info results
#       end
#     end
#   end
#
#   def filename
#     format pattern, name
#   end
#
#   alias_method :to_s, :filename
#
#   def info(results)
#     longest = results.keys.group_by(&:size).max
#     length = longest.nil? ? 0 : longest.first
#     applied, ignored = results.partition do |key, value|
#       ENV[key] == value
#     end
#     [
#       Results.for(:applied).new(self, applied, length),
#       Results.for(:ignored).new(self, ignored, length),
#     ].map(&:to_s).compact.push("\n").join("\n")
#   end
#
# private
#
#   @@default_hook = -> file, &loader { loader.call }
#
#   def default_hook
#     @@default_hook
#   end
#
#   module Utils
#
#     def without_leading_comments(file)
#       file.each_line.drop_while do |line|
#         comment? line
#       end
#     end
#
#     def comment?(line)
#       line.start_with? '#'
#     end
#
#     def variable(line)
#       line.match(/^\s*?(?<name>\b.*\b)=(?<value>\b\S*\b)?\s*?$/)
#     end
#
#   end
#
#   class Template < self
#
#     include Utils
#
#     attr_reader :content
#
#     def initialize(name, pattern =  Starenv.pattern, content = [])
#       @content = content
#       super name, [], pattern, nil
#     end
#
#     def parse
#       File.open(filename) do |lines|
#         yield without_leading_comments lines
#       end
#     end
#
#     def write
#       File.open(filename, 'w') do |file|
#         content.each do |line|
#           line = yield line
#           file.puts line if line
#         end
#       end
#     end
#
#   end
#
# end
