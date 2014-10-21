# -*- coding: utf-8 -*-
# Bamboo worker tests
module BambooWorker
  # shell tests
  module Shell
    # Conditional If class
    class If < Conditional
      # @see BambooWorker::Shell::Conditional#close
      def close
        Node.new('fi', options)
      end
    end
  end
end
