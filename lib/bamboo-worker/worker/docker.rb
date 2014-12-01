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
      # @param [String] name Name of the project
      # @param [Config] config Bamboo worker configuration
      # @param [Travis::Yaml::Nodes::Root] project_config Configuration file
      # @param [String] script Script to run on docker
      # @param [Slop] _opts Slop options
      # @param [Array] args Docker arguments
      #
      # @return [String]
      #
      def run(name, config, project_config, script, _opts, args)
        return false unless config.key?('docker')

        @name = name
        @config = config['docker']
        @project_config = project_config

        command = docker_command(script, args)
        return false unless command

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

        return false if container.nil?

        cmd = @executable.dup
        cmd << ' run -t'
        cmd << " -w '#{remote_path}/#{@name}'"
        cmd << " --entrypoint '/bin/bash'"
        cmd << " -v #{base_path}:#{remote_path}"
        cmd << " '#{container}'" unless container.nil?
        cmd << " --login -c '"
        cmd << "chmod +x #{remote_path}/#{File.basename(script)};"
        cmd << " #{remote_path}/#{File.basename(script)}"
        cmd << " #{args}" unless args.empty?
        cmd << "'"
        cmd
      end

      ##
      # Return container address
      #
      # @return [String]
      def container
        @config['containers'][@project_config.language.to_s] if
          @config.key?('containers') &&
          @config['containers'].key?(@project_config.language.to_s)
      end
    end
  end
end
