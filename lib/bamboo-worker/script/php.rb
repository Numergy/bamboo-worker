# -*- coding: utf-8 -*-
# Bamboo worker module
module BambooWorker
  # Script module
  class Script
    #  language
    class Php < Default
      # Setup language with phpenv
      #
      def setup
        super
        # Phpenv is a fork of Rbenv, so it's normal to use the RBENV_VERSION
        # variable -_-'
        #
        export 'RBENV_VERSION', "$(phpenv versions | grep #{@config.php} " \
        "| tail -1 | sed 's/[^0-9.]*\\([0-9.]*\\).*/\\1/'" \
        "| sed -e 's/^[ \\t]*//')"
        self.if('-z "$RBENV_VERSION"') do |klass|
          klass.failure("#{@config.php} not found")
        end

        export('BAMBOO_PHP_VERSION', @config.php, echo: false)
      end

      # Announce php and phpenv version
      #
      def announce
        cmd 'php --version'
        cmd 'phpenv --version'
      end

      # Default test script for php
      #
      def script
        failure('No script found.')
      end
    end
  end
end
