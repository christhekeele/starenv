module Starenv
  class File < ::File
    class Template < self

      def initialize(name, mode = 'r+', *args)
        super name, mode, *args
      end

      attr_reader :files

      def header
        %r{^#\sfile:\s(\w+).*?$}mi
      end

      def parse
        tap do
          unless parsed?
            require 'pry'; binding.pry
            @files = Hash[
              read.split(header).drop(1).each_slice(2).map do |key, value|
                [ key.to_sym, Parser.new(value.strip.lines).call ]
              end
            ]
          end
        end
      end

      def parsed?
        !!files
      end

    end
  end
end
