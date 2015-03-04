# -*- coding: utf-8 -*-
BambooWorker::CLI.options.command 'run' do
  banner 'Usage: bamboo-worker run [OPTIONS] [WORKER ARGS]'
  description 'Run bash script on worker'
  separator "\nOptions:\n"

  on(:d=, :destination=, 'Destination path to saving files.',
     default: Dir.tmpdir)
  on(:w=, :worker=, 'Worker to use to run scripts.',
     default: 'docker')
  on(:c=, :config=, 'Build from file and run script.',
     default: '.travis.yml')

  run do |opts, args|
    current_dir = BambooWorker::CLI.current_dir
    config = BambooWorker::Config.new(BambooWorker::CLI.worker_config_path)
    config_path = BambooWorker::CLI.config_path(opts[:c])
    project_config = Travis::Yaml.load(File.read(config_path))
    worker =
      Object.const_get('BambooWorker')
      .const_get('Worker')
      .const_get(opts[:w].capitalize).new

    BambooWorker::CLI.options.parse %W( build -c #{opts[:c]} -d #{opts[:d]})

    files = Dir.glob("#{opts[:d]}/#{File.basename(current_dir)}*.sh")
    begin
      files.each do |file|
        result = worker.run(current_dir,
                            config,
                            project_config,
                            file,
                            opts,
                            args)
        fail SystemCallError, 'Can not run command' unless result
      end
    rescue SystemCallError => e
      puts 'Build failed!'
      puts e.message
      exit 1
    ensure
      files.each do |file|
        puts "Remove #{file}"
        File.unlink(file)
      end
    end
  end
end
