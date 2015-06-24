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
          unless loaded?
            (hook || default_hook).call self do
              File.parse(name).environment
            end
          end
        end
      end

      def loaded?
        !!file
      end

    private

      def default_hook
        @@default_hook ||= -> file, &loader { loader.call }
      end

    end
  end
end
