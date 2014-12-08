# -*- coding: utf-8 -*-
# Bamboo worker module
module BambooWorker
  # Script module
  class Script
    # Python language
    class Python < Default
      # Setup language with pyenv
      #
      def setup
        super
        export 'PYENV_VERSION', '$(pyenv versions ' \
        "| grep ' #{@config.python}' " \
        "| tail -1 | sed 's/[^0-9.]*\\([0-9.]*\\).*/\\1/'" \
        "| sed -e 's/^[ \\t]*//')"
        self.if('-z "$PYENV_VERSION"') do |klass|
          klass.failure("#{@config.python} not found")
        end

        export('BAMBOO_PYTHON_VERSION', @config.python, echo: false)
      end

      # Announce python, pyenv and bundle version
      #
      def announce
        cmd 'python --version'
        cmd 'pip --version'
        cmd 'pyenv --version'
      end

      # Default install action for python
      #
      def install
        self.if('-f Requirements.txt') do |klass|
          klass.cmd 'pip install -r Requirements.txt', retry: true
        end

        elif '-f requirements.txt' do |klass|
          klass.cmd 'pip install -r requirements.txt', retry: true
        end

        self.else do |klass|
          klass.echo('Could not locate requirements.txt.')
        end
      end

      # Default test script for python
      #
      def script
        failure('No script found.')
      end
    end
  end
end
