require 'starenv/environment'
require 'starenv/variable'

module Starenv
  class File < ::File
    class Parser

      attr_accessor :lines

      def initialize(lines)
        @lines = lines
      end

      def call
        Environment.new(
          Hash[
            lines.map(&:strip).select do |line|
              line =~ Variable.line
            end.compact.map do |line|
              variable = Variable.from line
              [ variable.name, variable ]
            end
          ]
        )
      end

    end
  end
end
