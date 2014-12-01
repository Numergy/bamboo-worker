# -*- coding: utf-8 -*-
module BambooWorker
  # Config class
  class Config < Hash
    attr_reader :config_file

    def initialize(config_file = nil)
      return if config_file.nil?

      @config_file = config_file
      unless File.exist?(@config_file)
        dirname = File.dirname(@config_file)
        Dir.mkdir(dirname) unless File.directory?(dirname)
        File.write(@config_file, '')
      end

      content = File.read(@config_file)
      self.merge!(YAML.load(File.read(@config_file))) unless content.empty?
    end

    def save
      File.open(@config_file, 'w+') do |file|
        file.write(to_yaml)
      end
    end
  end
end
