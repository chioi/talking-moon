require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec)

task :test => :spec

task :default do
  ruby "lib/chat_server.rb"
end