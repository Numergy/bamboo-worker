# -*- coding: utf-8 -*-
BambooWorker::CLI.options.command 'build' do
  banner 'Usage: bamboo-worker build [DIRECTORY] [OPTIONS]'
  description 'Build bash script from yaml file'
  separator "\nOptions:\n"

  on :c=, :config=, 'Build from file and run script (default: .travis.yml)'

  run do |_opts, args|
    current_dir = File.expand_path(args[0] || Dir.pwd)
    puts current_dir
  end
end
