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
        cmd "rbenv local #{config.ruby}"
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
