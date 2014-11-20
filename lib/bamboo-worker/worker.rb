# -*- coding: utf-8 -*-
# Bamboo worker module
module BambooWorker
  # Worker module
  module Worker
    autoload :Docker, 'bamboo-worker/worker/docker'

    # Abstract class for workers
    class Abstract
      attr_reader :executable

      # Initialize worker
      #
      # @param [string] executable Executable script for the worker
      #
      def initialize(executable)
        fail "Can't find executable #{executable}, or is not executable." unless
          File.executable?(executable)
        @executable = executable
      end

      # Run script on worker
      #
      # @param [string] script Script to run on worker
      #
      def run(_script)
        fail NotImplementedError
      end
    end
  end
end
