require 'rake' unless defined? Rake

require 'highline'

require 'starenv'
require 'starenv/file/template'

module Starenv
  module Tasks

    extend self
    extend Rake::DSL

    task starenv: 'starenv:load'

    namespace :starenv do

      task :require do
        require 'starenv'
      end

      task load: :require do
        Starenv.load
      end

      task dry_run: :require do
        Starenv.load Hash.new
      end

    end

    namespace :envs do

      desc "Creates starenv files according to template file."
      task :init, %i[template] => %i[starenv] do |t, args|
        init_from args.with_defaults(template: :example)
      end
      #
      # desc "Adds a new environment variable to starenv."
      # task new: :starenv, %i[name value file] do |t, args|
      #   new_variable args.with_defaults(file: Starenv.files.tsort.last)
      # end
      #
      # desc "Sets a starenv variable."
      # task set: :starenv, %i[name value file] do |t, args|
      #   set_variable args.with_defaults(file: Starenv.files.tsort.first)
      # end
      #
      # desc "Shows the value of a starenv variable."
      # task get: :starenv, %i[name file] do |t, args|
      #   get_variable args.with_defaults(file: Starenv.files.tsort.first)
      # end

    end

    def init_from(template: :example, noop: false, verbose: true)
      File::Template.touch(template, noop: noop, verbose: verbose).parse.files.each do |file, env|
        require 'pry'; binding.pry
      end
    end

    # def init_from(template: :example, pattern: Starenv.pattern)
    #   EnvFile::Template.new(file, pattern).parse do |lines|
    #     chunk_into_files(lines).each do |file, lines|
    #       file = EnvFile::Template.new(file, pattern, lines)
    #       if not File.exists?(file.filename) or console.agree(console.color("Do you want to override your current #{file.filename}?", [:bold, :yellow]))
    #         console.say "Generating #{file.filename}..."
    #         file.write do |line|
    #           line.tap do |line|
    #             if variable = file.variable(line) and not variable[:value]
    #               line[-1] = console.ask("Enter a value for #{variable[:name]}:")
    #             end
    #           end
    #         end
    #       end
    #     end
    #   end
    # end

    def new_variable(name:, value:, file: Starenv.files.tsort.last || :core)
      file = EnvFile.new(file, [], pattern, nil)
    end

    def set_variable(name, value:, file: Starenv.files.tsort.last || :core)
      file = EnvFile.new(file, [], pattern, nil)
    end

    def get_variable(name, value:, file: Starenv.files.tsort.last || :core)
      file = EnvFile.new(file, [], pattern, nil)
    end

  private

    def console(*args)
      @@console ||= HighLine.new(*args)
    end

    def chunk_into_files(lines)
      lines.reduce({initial: []}) do |files, line|
        if file = line[/^#\s+?FILE:\s+?(?<file>\w+)/, :file]
          previous = files[files.keys.last]
          files[file] = []
          files[file] << previous.pop if previous
          files.delete(:initial)
        end
        files[files.keys.last] << line
        files
      end
    end

  end
end
