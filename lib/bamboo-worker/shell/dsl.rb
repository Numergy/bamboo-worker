# -*- coding: utf-8 -*-
# Bamboo worker module
module BambooWorker
  # Shell module
  module Shell
    # Dsl module
    module Dsl
      # Execute command
      #
      # @param [String] code Command to execute
      # @param [Array] args Arguments
      #
      def cmd(code, *args)
        node = Cmd.new(code, *merge_options(args))
        raw(node)
      end

      # Create node
      #
      # @param [Mixed] code Command to execute
      # @param [Array] args Arguments
      #
      def raw(code, *args)
        args = merge_options(args)
        pos = args.last.delete(:pos) || -1
        node = code.is_a?(Node) ? code : Node.new(code, args)
        nodes.insert(pos, node)
      end

      # Export env var
      #
      # @param [String] name Name
      # @param [String] value Value
      # @param [Hash] options Options
      #
      def export(name, value, options = {})
        cmd "export #{name}=#{value}", { assert: false }.merge(options)
      end

      # Insert new line
      #
      def newline
        raw 'echo'
      end

      # Display failure message
      #
      # @param [String] message Message to display
      #
      def failure(message)
        export 'BAMBOO_CMD', 'no_script', echo: false
        echo message
        raw 'exit 1'
      end

      # Display failure message
      #
      # @param [String] message Message to display
      # @param [Hash] options Node options
      #
      def echo(message = '', options = {})
        if message.empty?
          newline
        else
          cmd "echo '#{message.gsub(/'/) { "\\\'\'" }}'",
              { assert: false, echo: false, timing: false }.merge(options)
        end
      end

      # Create if statment
      #
      def if(*args, &block)
        args = merge_options(args)
        els_ = args.last.delete(:else)
        nodes << If.new(*args, &block)
        self.else(els_, args.last) if els_
        nodes.last
      end

      # Create elif statement
      #
      def elif(*args, &block)
        args = merge_options(args)
        els_ = args.last.delete(:else)
        nodes.last.raw Elif.new(*args, &block)
        self.else(els_, args.last) if els_
        nodes.last
      end

      # Create else statement
      #
      def else(*args, &block)
        args = merge_options(args)
        nodes.last.raw Else.new(args, &block)
        nodes.last
      end

      private

      # Merge options
      #
      # @param [Array] args Arguments
      # @param [Hash] options Options
      #
      # @return [Array]
      #
      def merge_options(args, options = {})
        options = (args.last.is_a?(Hash) ? args.pop : {}).merge(options)
        args << options
      end
    end
  end
end
