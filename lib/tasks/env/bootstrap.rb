require 'highline/import'
Kernel.def_delegator :$terminal, :color

namespace :bootstrap do
  
  desc "Create local .env files based on .env.example"
  task :envs do
    bootstrap_envs
  end
    
  task :env do
    bootstrap_envs /^\.env$/
  end
  
  namespace :env do
    %i[development test production local].each do |type|
      task type do
        bootstrap_envs /^\.env\.#{type}$/
      end
    end
  end
  
  def bootstrap_envs(filename_pattern=/^\.env(\.\w+)?$/)
    parse('.env.example') do |lines|
      chunk_into_files(lines).each do |filename, lines|
        bootstrap_file filename, lines if filename[filename_pattern]
      end
    end
  end
  
  def parse(filename)
    File.open(filename) do |file|
      yield(without_leading_comments(file))
    end
  end
  
  def chunk_into_files(lines)
    lines.reduce({initial: []}) do |files, line|
      if filename = line[/^#.+(?<filename>\.env(\.\w+)?)/, :filename]
        previous = files[files.keys.last]
        files[filename] = []
        files[filename] << previous.pop if previous
        files.delete(:initial)
      end
      files[files.keys.last] << line
      files
    end
  end
  
  def bootstrap_file(filename, lines)
    say "Bootstrapping #{filename}..."
    if not File.exists?(filename) or agree(color("Do you want to override your current #{filename}?", [:bold, :yellow]))
      File.open(filename, 'w') do |file|
        lines.each do |line|
          if line.ends_with?("=\n") and not comment?(line)
            line[-1] = ask("Enter a value for #{env_var(line)}:")
          end
          file.puts line
        end
      end
    end
  end
  
  def comment?(line)
    line.starts_with? '#'
  end
  
  def without_leading_comments(file)
    file.each_line.drop_while do |line|
      comment? line
    end
  end
  
  def env_var(line)
    line[/^\s*?(?<value>\b.*\b)=/, :value]
  end
  
end
