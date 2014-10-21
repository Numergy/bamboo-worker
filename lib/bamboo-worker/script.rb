# -*- coding: utf-8 -*-
# Bamboo worker module
module BambooWorker
  # Script class
  class Script
    attr_reader :stages

    # Initialize script
    #
    # @param [string] File name
    #
    def initialize(file)
      fail ArgumentError, "File \"#{file}\" not found" unless
        File.exist?(file)

      file_content = File.read(file)
      @stages = []

      Travis::Yaml.matrix(file_content).each do |matrix|
        begin
          require "bamboo-worker/script/#{matrix.language}"
          script = Script.const_get(matrix.language.capitalize).new(matrix)
        rescue LoadError
          raise ArgumentError, "Can't load \"#{matrix.language}\" language"
        end
        @stages << Stages.new(script)
      end
    end

    def compile
      scripts = []
      @stages.each do |stage|
        stage.builtin_stages
        stage.custom_stages
        content = Template
          .render(File.read("#{templates_path}/header.sh.erb"))
        content += Template
          .render(File.read("#{templates_path}/footer.sh.erb"),
                  nodes: stage.nodes)
        scripts << content
      end

      scripts
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
