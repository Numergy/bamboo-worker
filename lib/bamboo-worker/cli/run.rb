# -*- coding: utf-8 -*-
BambooWorker::CLI.options.command 'run' do
  banner 'Usage: bamboo-worker build [DIRECTORY] [OPTIONS]'
  description 'Run bash script on worker'
  separator "\nOptions:\n"

  run do |_opts, args|
    current_dir = File.expand_path(args[0] || Dir.pwd)
    puts current_dir
  end
end
