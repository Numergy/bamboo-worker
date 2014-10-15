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
      begin
        require "bamboo-worker/script/#{config.language}"
        @script = Script.const_get(config.language.capitalize).new(@config)
      rescue
        raise ArgumentError, "Can't load \"#{config.language}\" language"
      end

      @stack = Stages.new(@script)
    end

    def compile
      @stack.builtin_stages
      @stack.custom_stages
      puts Template
        .render(File.read("#{templates_path}/footer.sh.erb"),
                nodes: @stack.nodes)
    end

    # Get templates directory path
    #
    # @return [String]
    #
    def templates_path
      File.expand_path('../../../templates',
                       Pathname.new(__FILE__).realpath)
    end
  end
end
