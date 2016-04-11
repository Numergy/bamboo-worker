# -*- coding: utf-8 -*-
module BambooWorker
  # Config class
  class Config < Hash
    ##
    # Config file path
    #
    # @return [String]
    #
    attr_reader :config_file

    ##
    # Initialize configuration file and Hash.
    # Create directory and file if there are not found
    #
    # @param [String] config_file Config file to use
    #
    def initialize(config_file = nil)
      return if config_file.nil?

      @config_file = config_file
      unless File.exist?(@config_file)
        dirname = File.dirname(@config_file)
        Dir.mkdir(dirname) unless File.directory?(dirname)
        File.write(@config_file, '')
      end

      content = File.read(@config_file)
      merge!(YAML.load(File.read(@config_file))) unless content.empty?
    end

    ##
    # Save configuration in config_file
    #
    def save
      File.open(@config_file, 'w+') do |file|
        file.write(to_yaml)
      end
    end
  end
end
