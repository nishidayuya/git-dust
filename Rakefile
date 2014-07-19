require "bundler/gem_tasks"
require "rspec/core/rake_task"
require "rubocop/rake_task"

RSpec::Core::RakeTask.new

RuboCop::RakeTask.new do |task|
  task.patterns = %w(lib/**/*.rb spec/**/*.rb **/*.gemspec)
end

task :default => %i(rubocop spec)
