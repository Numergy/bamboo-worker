# -*- coding: utf-8 -*-
# Bamboo worker tests
module BambooWorker
  # shell tests
  module Shell
    # Conditional class
    class Conditional < Node
      include Dsl

      attr_reader :open, :close, :nodes

      # Initialize conditionnal class
      #
      # @param [String] condition Shell condition
      # @param [Array] *args Arguments
      # @param [Block] &_block Block
      def initialize(condition, *args, &_block)
        args.unshift(args.last.delete(:then)) if args.last.is_a?(Hash) &&
          args.last[:then]

        args = *condition if name == 'else'
        condition = "[[ #{condition} ]]" unless name == 'else'

        @options = args.last.is_a?(Hash) ? args.pop : {}
        @level = @options.delete(:level) || 0
        @nodes = []

        args.map do |node|
          cmd(node, options)
        end

        yield(self) if block_given?

        @open = Node.new("#{name} #{condition}; then", options)
      end

      # Return name of the current class
      #
      # @return [String]
      #
      def name
        self.class.name.split('::').last.downcase
      end

      # @see BambooWorker::Shell::Node#to_s
      #
      def to_s
        [open,
         nodes.map(&:to_s).join("\n").indent(level),
         close].compact.join("\n")
      end

      # @see BambooWorker::Shell::Dsl#cmd
      #
      def cmd(code, *args)
        super(code, *merge_options(args, level: 1))
      end

      # @see BambooWorker::Shell::Dsl#raw
      #
      def raw(code, *args)
        super(code, *merge_options(args, level: 1))
      end
    end
  end
end
