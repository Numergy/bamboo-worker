# -*- coding: utf-8 -*-
# Bamboo worker module
module BambooWorker
  # Script module
  class Script
    # Ruby language
    class Ruby < Default
      ##
      # Default configuration for ruby
      #
      # @return [Hash]
      #
      DEFAULTS = {
        'gemfile' => 'Gemfile'
      }

      # Setup language with rbenv
      #
      def setup
        super
        export 'RBENV_VERSION', "$(rbenv versions | grep #{@config.ruby} " \
        "| tail -1 | sed 's/[^0-9.]*\\([0-9.]*\\(-[a-z0-9]*\\)*\\).*/\\1/'" \
        "| sed -e 's/^[ \\t]*//')"
        self.if('-z "$RBENV_VERSION"') do |klass|
          klass.failure("Ruby version '#{@config.ruby}' not found")
        end

        export('BAMBOO_RUBY_VERSION', @config.ruby, echo: false)
      end

      # Announce ruby, rbenv and bundle version
      #
      def announce
        cmd 'ruby --version', echo: true
        cmd 'rbenv --version', echo: true
        gemfile?(then: 'bundle --version', echo: true)
      end

      # Default install action for ruby
      #
      def install
        gemfile?(then: 'bundle install --jobs=3', retry: true, echo: true)
      end

      # Default test script for ruby
      #
      def script
        gemfile?(then: 'bundle exec rake', else: 'rake',
                 assert: true,
                 echo: true)
      end

      private

      # Test if gemfile exists
      #
      # @param [Array] args Arguments
      # @param [Block] block Block
      #
      def gemfile?(*args, &block)
        self.if("-f #{DEFAULTS['gemfile']}", *args, &block)
      end
    end
  end
end
