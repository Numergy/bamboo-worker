# -*- coding: utf-8 -*-
require 'tempfile'

BambooWorker::CLI.options.command 'build' do
  banner 'Usage: bamboo-worker build [OPTIONS]'
  description 'Build bash script from yaml file'
  separator "\nOptions:\n"

  on(:c=, :config=, 'Build from file and run script (default: .travis.yml)',
     default: '.travis.yml')
  on(:d=, :destination=, 'Destination path to saving files (default: /tmp)',
     default: Dir.tmpdir)

  run do |opts, _args|
    current_dir = File.expand_path(Dir.pwd)
    script = BambooWorker::Script.new("#{current_dir}/#{opts[:c]}")
    dir_name = File.basename(current_dir)
    idx = 0
    script.compile.each do |f|
      File.open("#{opts[:d]}/#{dir_name}#{idx}.sh", 'w+', 0755) do |file|
        file.write(f)
        puts "File writes in #{file.path}"
      end

      idx += 1
    end
  end
end
