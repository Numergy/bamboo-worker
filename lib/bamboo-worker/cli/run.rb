# -*- coding: utf-8 -*-
BambooWorker::CLI.options.command 'run' do
  banner 'Usage: bamboo-worker run [OPTIONS] [WORKER ARGS]'
  description 'Run bash script on worker'
  separator "\nOptions:\n"

  on(:d=, :directory=, 'Path where are stored scripts (default: /tmp)',
     default: '/tmp')
  on(:w=, :worker=, 'Worker to use to run scripts (default: docker)',
     default: 'docker')

  run do |opts, args|
    dir_name = File.basename(File.expand_path(Dir.pwd))

    worker =
      Object.const_get('BambooWorker')
      .const_get('Worker')
      .const_get(opts[:w].capitalize).new

    scripts = Dir.glob("#{opts[:d]}/#{dir_name}*.sh")
    scripts.each do |script|
      worker.run(script, args)
    end
  end
end
