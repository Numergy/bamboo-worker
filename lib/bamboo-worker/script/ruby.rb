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

      def setup
        super
        cmd "rbenv local #{config.ruby}"
      end

      def announce
        cmd 'ruby --version'
        cmd 'rbenv --version'
        gemfile?(then: 'bundle --version')
      end

      def install
        gemfile?(then: 'bundle install')
      end

      def script
        gemfile?(then: 'bundle exec rake', else: 'rake')
      end

      private

      def gemfile?(*args, &block)
        self.if("-f #{DEFAULTS['gemfile']}", *args, &block)
      end
    end
  end
end
