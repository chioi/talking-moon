# frozen_string_literal: true

require 'rspec'
require 'rack/test'
require 'rspec/core/rake_task'
require 'docker'
require 'dotenv/tasks'

task test: :dotenv do
  RSpec::Core::RakeTask.new(:spec).run_task(verbose: true)
end

task :default do
  `rackup -p 4567 -o 0.0.0.0`
end

# TODO: Find a way to properly parse the stream
task :build do
  Docker::Image.build_from_dir('.', 'repo' => 'chat_server') do |v|
    if (log = JSON.parse(v.to_json, object_class: OpenStruct))
      $stdout.puts log
    end
  end
end
