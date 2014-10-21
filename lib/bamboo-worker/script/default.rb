# -*- coding: utf-8 -*-
# Bamboo worker module
module BambooWorker
  # Script class
  class Script
    # Default class for languages tasks
    class Default
      include ::BambooWorker::Shell

      attr_accessor :nodes, :config

      # Initialize script language
      #
      # @param [Travis::Yaml::Matrix::Entry] config Configuration to used
      #
      def initialize(config)
        @nodes = []
        @config = config
      end

      # Setup language for the build
      #
      def setup
        # overwrite
      end

      # Announce language for the build
      #
      def announce
        # overwrite
      end
    end
  end
end
