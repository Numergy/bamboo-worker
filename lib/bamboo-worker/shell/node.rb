require 'bamboo-worker/core/string/indent'

# Bamboo worker module
module BambooWorker
  # Shell module
  module Shell
    # Node class
    class Node
      attr_reader :code, :options, :level

      ##
      # Initialize node
      #
      def initialize(*args)
        @options = args.last.is_a?(Hash) ? args.pop : {}
        @level = options.delete(:level) || 0
        @code = args.first
      end

      ##
      # Render node line
      #
      # @return [String]
      #
      def to_s
        BambooWorker::Logger.debug(code.indent(@level)) if
          is_a?(::BambooWorker::Shell::Cmd) && @level.zero?
        code.indent(@level)
      end

      ##
      # Shell escape string
      #
      # @param [String] code String to escape
      #
      # @return [String]
      #
      def escape(code)
        Shellwords.escape(code)
      end
    end
  end
end
