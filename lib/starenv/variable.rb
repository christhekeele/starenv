module Starenv
  class Variable < Struct.new(:name, :value, :default)

    class << self

      def line
        %r{
          \A
          (?:export\s+)?    # optional export
          ([\w\.]+)         # key
          (?:\s*=\s*|:\s+?) # separator
          (                 # optional value begin
            '(?:\'|[^'])*'  #   single quoted value
            |               #   or
            "(?:\"|[^"])*"  #   double quoted value
            |               #   or
            [^#\n]+         #   unquoted value
          )?                # value end
          (?:\s*\#.*)?      # optional comment
          \z
        }x
      end

      def from(input)
        new *line.match(input).captures
      end

    end

    def initialize(name, value, default = nil)
      super name, value, default
    end

    def to_s
      value.to_s
    end

  end
end
