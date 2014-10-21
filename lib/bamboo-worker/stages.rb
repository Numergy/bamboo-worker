# -*- coding: utf-8 -*-
# Bamboo worker module
module BambooWorker
  # Stages class
  class Stages
    include ::BambooWorker::Shell

    attr_reader :config, :script, :nodes

    STAGES = {
      builtin: [:setup,
                :env,
                :announce],
      custom: [:before_install,
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
    def initialize(script)
      @script = script
      @config = script.config
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
        run_stage(stage)
      end
    end

    def run_stage(stage)
      if stage == :after_result
        build_builtin_stage(stage)
      elsif @script.respond_to?(stage, false) && !config.key?(stage.to_s)
        @script.send(stage)
      else
        build_custom_stage(stage)
      end
    end

    def build_builtin_stage(stage)
      send(stage)
    end

    def build_custom_stage(stage, klass = self)
      cmds = *config[stage.to_s]
      cmds.each do |command|
        klass.cmd(command, assert: assert_stage?(stage))
      end
    end

    def env
      export 'BAMBOO', 'true', echo: false
      export 'CI', 'true', echo: false
      export 'CONTINIOUS_INTEGRATION', 'true', echo: false
      # @TODO global and matrix env vars
    end

    def setup
      @script.setup
    end

    def announce
      @script.announce
    end

    def after_result
      self.if('$TEST_RESULT = 0') do |klass|
        build_custom_stage('after_success', klass)
      end if config['after_success']

      self.if('$TEST_RESULT != 0') do |klass|
        build_custom_stage('after_failure', klass)
      end if config['after_failure']
    end

    def assert_stage?(stage)
      [:before_install, :install, :before_script, :script].include?(stage)
    end
  end
end
