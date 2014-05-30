require 'bundler/gem_tasks'
require 'rspec/core/rake_task'

task :default => :run_all

task :run_all => [:spec, :install] {}

desc 'Run RSpec tests'
RSpec::Core::RakeTask.new(:spec)
