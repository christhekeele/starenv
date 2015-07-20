require 'starenv/file'

module Starenv
  class File < ::File
    class Node < Struct.new(:name, :dependencies, :hook)

      attr_reader :environment

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
          @environment = (hook || default_hook).call self do
            File.parse(name).environment
          end
        end
      end

      def loaded?
        !!@environment
      end

    private

      def default_hook
        @@default_hook ||= -> file, &loader { loader.call }
      end

    end
  end
end
