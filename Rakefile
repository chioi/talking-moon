require "rspec/core/rake_task"
require "docker"

RSpec::Core::RakeTask.new(:spec)

task :default do
  ruby "lib/chat_server.rb"
end

# TODO: Find a way to properly parse the stream
task :build do
  Docker::Image.build_from_dir('.', { "repo" => "chat_server" }) do |v|
    if (log = JSON.parse(v.to_json, object_class: OpenStruct))
      $stdout.puts log
    end
  end
end

task :test => :spec
