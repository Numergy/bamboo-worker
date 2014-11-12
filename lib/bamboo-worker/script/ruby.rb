# -*- coding: utf-8 -*-
# Bamboo worker module
module BambooWorker
  # Script module
  class Script
    # Ruby language
    class Ruby < Default
      DEFAULTS = {
        'gemfile' => 'Gemfile'
      }

      # Setup language with rbenv
      #
      def setup
        super
        export 'RBENV_VERSION', "$(rbenv versions | grep #{@config.ruby} " \
        "| tail -1 | sed 's/[^0-9.]*\\([0-9.]*-[a-z0-9]*\\).*/\\1/'" \
        "| sed -e 's/^[ \\t]*//')"
        self.if('-z "$RBENV_VERSION"') do |klass|
          klass.cmd("echo '#{@config.ruby} not found'")
          klass.cmd('exit 1')
        end
      end

      # Announce ruby, rbenv and bundle version
      #
      def announce
        cmd 'ruby --version'
        cmd 'rbenv --version'
        gemfile?(then: 'bundle --version')
      end

      # Default install action for ruby
      #
      def install
        gemfile?(then: 'bundle install')
      end

      # Default test script for ruby
      #
      def script
        gemfile?(then: 'bundle exec rake', else: 'rake')
      end

      private

      # Test if gemfile exists
      #
      # @param [Array] *args Arguments
      # @param [Block] &block Block
      #
      def gemfile?(*args, &block)
        self.if("-f #{DEFAULTS['gemfile']}", *args, &block)
      end
    end
  end
end
