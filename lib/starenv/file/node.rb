require 'starenv/file'
require 'starenv/environment'

module Starenv
  class File < ::File
    class Node < Struct.new(:name, :dependencies, :hook)

      attr_accessor :loaded
      attr_reader :environment, :file

      def initialize(name, dependencies = [], hook = nil)
        super name, dependencies, hook
      end

      def load
        tap do
          load! unless loaded?
        end
      end

      def load!
        tap do
          begin
            @file = File.new(name)
            @environment = Loader.new(self, hook).call
          rescue Errno::ENOENT
            @environment = Environment.new
          end
        end
      end

      def loaded?
        !!loaded
      end

    private

      class Loader < Struct.new(:node, :hook)

        def initialize(node, hook = nil)
          super node, hook || default_hook
        end

        def load
          node.file.parse.environment.tap do
            node.loaded = true
          end
        end

        def call
          hook.call self or Environment.new({})
        end

        def default_hook
          @@default_hook ||= -> (loader) { loader.load }
        end

      end

    end
  end
end
