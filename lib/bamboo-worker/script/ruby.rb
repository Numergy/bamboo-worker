# -*- coding: utf-8 -*-
# Bamboo worker module
module BambooWorker
  # Script module
  class Script
    # Ruby language
    class Ruby < Default
      def setup
        super
        cmd "rbenv local #{config['ruby']}"
      end

      def announce
        cmd 'ruby --version'
        cmd 'rbenv --version'
      end

      def script
        cmd 'bundle exec rake'
      end

      private

      def gemfile?
      end
    end
  end
end
