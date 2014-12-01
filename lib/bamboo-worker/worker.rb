# -*- coding: utf-8 -*-
# Bamboo worker module
module BambooWorker
  # Worker module
  module Worker
    autoload :Docker, 'bamboo-worker/worker/docker'

    # Base class for workers
    class Base
      attr_reader :executable

      # Initialize worker
      #
      # @param [String] executable Executable script for the worker
      #
      def initialize(executable)
        fail "Can't find executable #{executable}, or is not executable." unless
          File.executable?(executable)
        @executable = executable
      end

      # Run script on worker
      #
      # @param [String] _name Name of the project
      # @param [Config] _config Bamboo worker configuration
      # @param [Travis::Yaml::Nodes::Root] _project_config Configuration file
      # @param [String] _script Script to run on worker
      # @param [Slop] _opts Slop options
      # @param [Array] _args worker's specific arguments
      #
      def run(_name, _config, _project_config, _script, _opts, _args)
        fail NotImplementedError
      end
    end
  end
end
