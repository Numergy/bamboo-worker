module BambooWorker
  module Worker
    # Docker worker
    class Docker < Base
      attr_reader :config, :host, :port, :name

      def initialize
        super '/usr/bin/docker'
      end

      # Run docker command
      #
      # @param [Travis::Yaml::Nodes::Root] config Configuration file
      # @param [String] script Script to run on docker
      # @param [Slop] opts Slop options
      # @param [Array] args Arguments for docker command
      #
      # @return [String]
      #
      def run(name, config, script, opts, args)
        @name = name
        @config = config
        @host = opts[:r]
        @port = opts[:p]
        system(docker_command(script, args))
        fail SystemCallError, 'System failed' unless
          $CHILD_STATUS.exitstatus == 0
      end

      private

      # Generate docker command to run script
      #
      # @param [Travis::Yaml::Nodes::Root] config Configuration file
      # @param [String] script Script to run on docker
      # @param [Array] args Arguments for docker command
      #
      # @return [String]
      #
      def docker_command(script, args)
        base_path = File.dirname(File.expand_path(script))
        entrypoint = '/bin/bash'
        remote_path = '/tmp/build'

        cmd = @executable.dup
        cmd << ' run -t'
        cmd << " -w '#{remote_path}/#{name}'"
        cmd << " --entrypoint '#{entrypoint}'"
        cmd << " -v #{base_path}:#{remote_path}"
        cmd << " '#{@host}" unless @host.nil?
        cmd << ":#{@port}" unless @port.nil?
        cmd << "/#{@config.language}-builder'"
        cmd << " --login -c '"
        cmd << "chmod +x #{remote_path}/#{File.basename(script)};"
        cmd << " #{remote_path}/#{File.basename(script)}"
        cmd << " #{args}" unless args.empty?
        cmd << "'"
        cmd
      end
    end
  end
end
