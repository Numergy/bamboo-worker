require 'bamboo-worker/core/string/indent'

# Bamboo worker module
module BambooWorker
  # Shell module
  module Shell
    # Node class
    class Node
      attr_reader :code, :options, :level

      def initialize(*args)
        @options = args.last.is_a?(Hash) ? args.pop : {}
        @level = options.delete(:level) || 0
        @code = args.first
      end

      def to_s
        code.is_a?(String) ? code.indent(@level) : code.to_s
      end

      def escape(code)
        Shellwords.escape(code)
      end
    end
  end
end
