# -*- coding: utf-8 -*-
module BambooWorker
  module Worker
    # Docker worker
    class Docker < Base
      attr_reader :config, :project_config, :name

      ##
      # Initialize program
      #
      def initialize
        super '/usr/bin/docker'
      end

      # Run docker command
      #
      # @param [String] path Path of the project
      # @param [Config] config Bamboo worker configuration
      # @param [Travis::Yaml::Nodes::Root] project_config Configuration file
      # @param [String] script Script to run on docker
      # @param [Slop] _opts Slop options
      # @param [Array] args Docker arguments
      #
      # @return [String]
      #
      def run(path, config, project_config, script, _opts, args)
        if !config.key?('docker') && !project_config.key?('docker')
          BambooWorker::Logger
            .error('Config or yaml file do not contains docker key.')
          return false
        end

        @path = path
        @config = config.key?('docker') ? config['docker'] : nil
        @project_config = project_config

        command = docker_command(script, args)
        return false unless command

        BambooWorker::Logger.debug('Run docker command:')
        BambooWorker::Logger.debug(command)
        system(command)
        fail SystemCallError, 'System failed' unless $CHILD_STATUS.success?
        true
      end

      private

      # Generate docker command to run script
      #
      # @param [String] script Script to run on docker
      # @param [Array] args Arguments for docker command
      #
      # @return [String]
      #
      def docker_command(script, args)
        base_path = File.dirname(File.expand_path(script))
        remote_path = '/tmp/build'
        script_path = '/tmp/script'

        if container.nil?
          BambooWorker::Logger.error('Container not found')
          return false
        end

        BambooWorker::Logger.info("Using container: #{container}")

        cmd = @executable.dup
        cmd << ' run -t --rm'
        %w(LANG LANGUAGE LC_ALL).each do |variable|
          cmd << " -e #{variable}=en_US.UTF-8"
        end
        cmd << ' -h $(hostname)'
        cmd << " -w '#{remote_path}'"
        cmd << " --entrypoint '/bin/bash'"
        cmd << " -v #{@path}:#{remote_path}"
        cmd << " -v #{base_path}:#{script_path}"
        cmd << " #{args.join(' ')}" unless args.empty?
        cmd << " '#{container}'"
        cmd << " --login -c '"
        cmd << "chmod +x #{script_path}/#{File.basename(script)};"
        cmd << " #{script_path}/#{File.basename(script)}"
        cmd << "'"
        cmd
      end

      ##
      # Return container address
      #
      # @return [String]
      def container
        return @project_config['docker']['container'] if
          @project_config.key?('docker') &&
          @project_config['docker'].key?('container')

        @config['containers'][@project_config.language.to_s] if
          @config.key?('containers') &&
          @config['containers'].key?(@project_config.language.to_s)
      end
    end
  end
end
