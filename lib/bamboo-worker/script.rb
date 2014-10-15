# -*- coding: utf-8 -*-
# Bamboo worker module
module BambooWorker
  # Script class
  class Script
    attr_reader :config

    # Initialize script
    #
    # @param [string] File name
    #
    def initialize(file)
      fail ArgumentError, "File \"#{file}\" not found" unless File.exist?(file)
      @config = Travis::Yaml.load(File.read(file))
      @script = Script.const_get(config.language.capitalize).new(@config)
      @stack = Stages.new(@script)
    end
  end
end
