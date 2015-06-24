require 'bundler/gem_tasks'

desc 'Open a pry console preloaded with this library'
task console: 'console:pry'

namespace :console do

  task :pry do
    sh 'bundle exec pry -I lib -r starenv.rb'
  end

  task :irb do
    sh 'bundle exec irb -I lib -r starenv.rb'
  end

end

require_relative 'lib/starenv/tasks'
