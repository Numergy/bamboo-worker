# -*- coding: utf-8 -*-
# Bamboo worker tests
module BambooWorker
  # shell tests
  module Shell
    # Conditional If class
    class Else < Conditional
      # @see BambooWorker::Shell::Conditional#open
      def open
        @open = Node.new('else', options)
      end
    end
  end
end
