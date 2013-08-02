require "bundler/gem_tasks"

desc "start irc client"
task :start do
  %x{ ruby lib/kptchan.rb }
end


task :default => [:spec]
begin
  require 'rspec/core/rake_task'
  RSpec::Core::RakeTask.new(:spec) do |spec|
    spec.pattern = 'spec/**/*_spec.rb'
    spec.rspec_opts = ['-cfs']
  end
rescue LoadError => e
end
