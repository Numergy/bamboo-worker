# Bamboo worker module
module BambooWorker
  # Shell module
  module Shell
    # Cmd class
    class Cmd < Node
      def code
        if opts.any?
          ['bamboo_cmd', escape(super), *opts].join(' ')
        else
          super
        end
      end

      def opts
        opts ||= []
        opts << '--assert' if options[:assert]
        opts << '--echo' if options[:echo]
        opts << '--retry' if options[:retry]
        opts << '--timing' if options[:timing]
        opts << "--display #{escape(options[:echo])}" if options[:echo]
          .is_a?(String)
        opts
      end
    end
  end
end
