# -*- coding: utf-8 -*-
# Bamboo worker module
module BambooWorker
  # Script module
  class Script
    # NodeJs language
    class NodeJs < Default
      # Setup language with ndenv
      #
      def setup
        super
        export 'NDENV_VERSION', "$(ndenv versions | grep #{@config.node_js} " \
        "| tail -1 | sed 's/[^0-9.]*\\(v[0-9.]*\\).*/\\1/'" \
        "| sed -e 's/^[ \\t]*//')"
        self.if('-z "$NDENV_VERSION"') do |klass|
          klass.failure("#{@config.node_js} not found")
        end

        export('BAMBOO_NODE_VERSION', @config.node_js, echo: false)
      end

      # Announce node_js and ndenv version
      #
      def announce
        cmd 'node --version'
        cmd 'npm --version'
        cmd 'ndenv --version'
      end

      # Default install action for node js
      #
      def install
        package?(then: 'npm install', retry: true, echo: true)
      end

      # Default test script for node_js
      #
      def script
        package?(then: 'npm test', else: 'make test',
                 assert: true,
                 echo: true)
      end

      private

      # Test if package file exists
      #
      # @param [Array] args Arguments
      # @param [Block] block Block
      #
      def package?(*args, &block)
        self.if('-f package.json', *args, &block)
      end
    end
  end
end
