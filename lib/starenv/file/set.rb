require 'tsort'

require 'starenv/file/node'

module Starenv
  class File < ::File
    class Set < Hash

      include TSort

      alias_method :tsort_each_node, :each_key

      def tsort_each_child(node)
        fetch(node).dependencies.each(&Proc.new)
      end

      def add(name, dependencies, hook)
        store name, Node.new(name, Array(dependencies).flatten, hook)
      end

    end
  end
end
