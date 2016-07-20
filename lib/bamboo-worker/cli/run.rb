# -*- coding: utf-8 -*-
# rubocop:disable Metrics/LineLength
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
  on(:l=, :log_level=, 'Log level (debug, info, warn, error, fatal, unknown)',
     default: 'info')

  run do |opts, args|
    BambooWorker::Logger.level(opts[:l])
    current_dir = BambooWorker::CLI.current_dir
    config = BambooWorker::Config.new(BambooWorker::CLI.worker_config_path)
    config_path = BambooWorker::CLI.config_path(opts[:c])
    project_config = Travis::Yaml.load(File.read(config_path))
    worker = Object.const_get('BambooWorker')
                   .const_get('Worker')
                   .const_get(opts[:w].capitalize).new

    BambooWorker::CLI.options.parse(%W(build -c #{opts[:c]} -d #{opts[:d]} -l #{opts[:l]}))

    files = Dir.glob("#{opts[:d]}/#{File.basename(current_dir)}*.sh")
    begin
      files.each do |file|
        result = worker.run(current_dir,
                            config,
                            project_config,
                            file,
                            opts,
                            args)
        raise SystemCallError, 'Can not run command' unless result
      end
    rescue SystemCallError => e
      BambooWorker::Logger.error('Build failed!')
      BambooWorker::Logger.error(e.message)
      exit 1
    ensure
      files.each do |file|
        BambooWorker::Logger.info("Remove #{file}")
        File.unlink(file)
      end
    end
  end
end
