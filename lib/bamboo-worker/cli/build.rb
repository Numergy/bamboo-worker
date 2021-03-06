# -*- coding: utf-8 -*-
require 'tempfile'

BambooWorker::CLI.options.command 'build' do
  banner 'Usage: bamboo-worker build [OPTIONS]'
  description 'Build bash script from yaml file'
  separator "\nOptions:\n"

  on(:c=, :config=, 'Build from file and run script.',
     default: '.travis.yml')
  on(:d=, :destination=, 'Destination path to saving files.',
     default: Dir.tmpdir)
  on(:l=, :log_level=, 'Log level (debug, info, warn, error, fatal, unknown)',
     default: 'info')

  run do |opts, _args|
    BambooWorker::Logger.level(opts[:l])
    current_dir = BambooWorker::CLI.current_dir
    script = BambooWorker::Script.new(BambooWorker::CLI.config_path(opts[:c]))
    dir_name = File.basename(current_dir)
    idx = 0
    script.compile.each do |f|
      File.open("#{opts[:d]}/#{dir_name}#{idx}.sh", 'w+', 0755) do |file|
        file.write(f)
        BambooWorker::Logger.info("File writes in #{file.path}")
      end

      idx += 1
    end
  end
end
