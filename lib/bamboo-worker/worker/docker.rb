module BambooWorker
  module Worker
    # Docker worker
    class Docker < Base
      def initialize
        super '/usr/bin/docker'
      end

      def run(script)
        exec docker_command(script)
      end

      private

      # Generate docker command to run script
      #
      # @param [string] script Script to run on docker
      #
      def docker_command(script)
        base_path = File.dirname(File.expand_path(script))
        container = 'builder/ruby'
        entrypoint = '/bin/bash'
        remote_path = '/tmp/build'
        docker_command = "--login -c 'cd #{remote_path}'; ./#{script}"

        cmd = @executable
        cmd << ' run -t -i'
        cmd << " --entrypoint '#{entrypoint}'"
        cmd << " -v #{base_path}:#{remote_path}"
        cmd << " #{container} #{docker_command}"
      end
    end
  end
end
