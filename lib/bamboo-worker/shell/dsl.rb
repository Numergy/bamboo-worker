# -*- coding: utf-8 -*-
# Bamboo worker module
module BambooWorker
  # Shell module
  module Shell
    # Dsl module
    module Dsl
      def cmd(code, *args)
        node = Cmd.new(code, *merge_options(args))
        raw(node)
      end

      def raw(code, *args)
        args = merge_options(args)
        pos = args.last.delete(:pos) || -1
        node = code.is_a?(Node) ? code : Node.new(code, args)
        nodes.insert(pos, node)
      end

      def export(name, value, options = {})
        cmd "export #{name}=#{value}", { assert: false }.merge(options)
      end

      def newline
        raw 'echo'
      end

      def if(*args, &block)
        args = merge_options(args)
        els_ = args.last.delete(:else)
        nodes << If.new(*args, &block)
        self.else(els_, args.last) if els_
        nodes.last
      end

      def elif(*args, &block)
        args = merge_options(args)
        els_ = args.last.delete(:else)
        nodes.last.raw Elif.new(*args, &block)
        self.else(els_, args.last) if els_
        nodes.last
      end

      def else(*args, &block)
        nodes.last.raw Else.new(*merge_options(args), &block)
        nodes.last
      end

      private

      def merge_options(args, options = {})
        options = (args.last.is_a?(Hash) ? args.pop : {}).merge(options)
        args << options
      end
    end
  end
end
