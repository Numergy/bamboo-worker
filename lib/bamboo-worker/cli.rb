# -*- coding: utf-8 -*-
module BambooWorker
  # CLI loader
  module CLI
    ##
    # Hash containing the default Slop options.
    #
    # @return [Hash]
    #
    SLOP_OPTIONS = {
      help: true,
      banner: 'Usage: bamboo-worker [COMMAND] [OPTIONS]'
    }.freeze

    ##
    # @return [Slop]
    #
    def self.options
      @options ||= default_options
    end

    ##
    # @return [Slop]
    #
    def self.default_options
      Slop.new(SLOP_OPTIONS.dup) do
        separator "\nOptions:\n"

        on :v, :version, 'Shows the current version' do
          puts CLI.version_information
        end
      end
    end

    ##
    # Returns a String containing some platform/version related information.
    #
    # @return [String]
    #
    def self.version_information
      "bamboo-worker v#{VERSION} on #{RUBY_DESCRIPTION}"
    end

    ##
    # Return current directory
    #
    # @return [String]
    #
    def self.current_dir
      File.expand_path(Dir.pwd)
    end

    ##
    # Return configuration path
    #
    # @param [String] config_file Config file name
    #
    # @return [String]
    #
    def self.config_path(config_file)
      ENV['TRAVIS_YAML'] || File.join(current_dir, config_file)
    end

    ##
    # Return worker configuration
    #
    # @return [String]
    #
    def self.worker_config_path
      ENV['WORKER_YAML'] || File.expand_path('~/.bamboo/worker.yml')
    end
  end
end
