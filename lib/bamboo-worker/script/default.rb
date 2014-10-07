# -*- coding: utf-8 -*-
# Bamboo worker module
module BambooWorker
  # Script class
  class Script
    # Default class for languages tasks
    class Default
      include ::BambooWorker::Shell

      attr_accessor :nodes

      def initialize
        @nodes = []
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
