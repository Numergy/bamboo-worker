# Bamboo worker module
module BambooWorker
  # Shell module
  module Shell
    # Cmd class
    class Cmd < Node
      # Overwrite code method if option is passed
      #
      # @return [String]
      def code
        if opts.any?
          ['bamboo_cmd', escape(super.to_s), *opts].join(' ')
        else
          super
        end
      end

      # List of available options for bamboo_cmd command
      #
      # @return [Array]
      def opts
        opts ||= []
        opts << '--assert' if options[:assert]
        opts << '--echo' if options[:echo]
        opts << '--retry' if options[:retry]
        opts << '--timing' if options[:timing]
        opts << "--display #{escape(options[:echo])}" if
          options[:echo].is_a?(String)
        opts
      end
    end
  end
end
