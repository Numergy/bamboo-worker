# -*- coding: utf-8 -*-
# Bamboo worker module
module BambooWorker
  # Stages class
  class Stages
    include ::BambooWorker::Shell
    attr_reader :config, :script, :nodes

    STAGES = {
      builtin: [:env,
                :announce],
      custom: [:setup,
               :before_install,
               :install,
               :before_script,
               :script,
               :after_result,
               :after_script]
    }

    # Initialize script
    #
    # @param [Travis::Yaml::Node::Root] Configuration
    # @param [BambooWorker::Script::Default] Language to used
    #
    def initialize(config, script)
      @config = config
      @script = script
      @nodes = []
      @script.nodes = @nodes
    end

    def builtin_stages
      STAGES[:builtin].each do |stage|
        build_builtin_stage(stage)
      end
    end

    def custom_stages
      STAGES[:custom].each do |stage|
        build_custom_stage(stage)
      end
    end

    def build_builtin_stage(stage)
      send(stage)
    end

    def build_custom_stage(stage)
      cmds = Array(config[stage])
      cmds.each do |command|
        cmd command
      end
    end

    def env
      export 'BAMBOO', 'true', echo: false
      export 'CI', 'true', echo: false
      export 'CONTINIOUS_INTEGRATION', 'true', echo: false
      # @TODO add custom env
    end

    def announce
      @script.announce
    end
  end
end
