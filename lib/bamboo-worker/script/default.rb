# -*- coding: utf-8 -*-
# Bamboo worker module
module BambooWorker
  # Script class
  class Script
    # Default class for languages tasks
    class Default
      include ::BambooWorker::Shell

      attr_accessor :nodes, :config

      def initialize(config)
        @nodes = []
        @config = config
      end

      def setup
        # overwrite
      end

      def announce
        # overwrite
      end
    end
  end
end
