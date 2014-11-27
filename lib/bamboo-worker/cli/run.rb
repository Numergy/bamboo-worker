# -*- coding: utf-8 -*-
BambooWorker::CLI.options.command 'run' do
  banner 'Usage: bamboo-worker run [OPTIONS] [WORKER ARGS]'
  description 'Run bash script on worker'
  separator "\nOptions:\n"

  on(:d=, :destination=, 'Destination path to saving files (default: /tmp)',
     default: Dir.tmpdir)
  on(:w=, :worker=, 'Worker to use to run scripts (default: docker)',
     default: 'docker')
  on(:c=, :config=, 'Build from file and run script (default: .travis.yml)',
     default: '.travis.yml')
  on(:r=, :remote_addr=, 'Worker remote address')
  on(:p=, :port=, 'Worker port address', as: Integer, default: 80)

  run do |opts, args|
    current_dir = File.expand_path(Dir.pwd)
    dir_name = File.basename(current_dir)
    config = Travis::Yaml.load(File.read("#{current_dir}/#{opts[:c]}"))

    BambooWorker::CLI.options.parse %W( build -c #{opts[:c]} -d #{opts[:d]})

    worker =
      Object.const_get('BambooWorker')
      .const_get('Worker')
      .const_get(opts[:w].capitalize).new

    files = Dir.glob("#{opts[:d]}/#{dir_name}*.sh")
    begin
      files.each do |file|
        worker.run(dir_name, config, file, opts, args)
      end
    rescue
      puts 'Build failed!'
      exit 1
    ensure
      files.each do |file|
        puts "Remove #{file}"
        File.unlink(file)
      end
    end
  end
end
