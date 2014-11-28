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
    # @param [BambooWorker::Script::Default] script Script language to use
    #
    def initialize(script)
      @script = script
      @config = script.config
      @nodes = []
      @script.nodes = @nodes
    end

    # Build all Builtin stages
    #
    def builtin_stages
      STAGES[:builtin].each do |stage|
        build_builtin_stage(stage)
      end
    end

    # Build all Custom stages
    #
    def custom_stages
      STAGES[:custom].each do |stage|
        run_stage(stage)
      end
    end

    # Run stage
    #
    # @param [String] stage Stage name
    #
    def run_stage(stage)
      export 'BAMBOO_STAGE', stage, echo: false
      if stage == :after_result
        build_builtin_stage(stage)
      elsif @script.respond_to?(stage, false) && !config.key?(stage.to_s)
        @script.send(stage)
      else
        build_custom_stage(stage)
      end
    end

    # Build builtin stage
    #
    # @param [String] stage Stage name
    #
    def build_builtin_stage(stage)
      export 'BAMBOO_STAGE', stage, echo: false
      send(stage)
    end

    # Build custom stage
    #
    # @param [String] stage Stage name
    # @param [Object] klass Object to send command
    #
    def build_custom_stage(stage, klass = self)
      cmds = *config[stage.to_s]
      cmds.each do |command|
        klass.cmd(command, assert: assert_stage?(stage), echo: true)
      end
    end

    # Generate env vars for the script
    #
    def env
      export 'BAMBOO', 'true', echo: false
      export 'CI', 'true', echo: false
      export 'CONTINUOUS_INTEGRATION', 'true', echo: false

      if @config.key?('env')
        @config['env']['global'].each do |line|
          custom_export(line)
        end unless @config['env']['global'].nil?
      end

      custom_export(@config.matrix_attributes[:env]) if
        @config.respond_to?('matrix_attributes') &&
        !@config.matrix_attributes[:env].nil?
    end

    # Setup build
    #
    def setup
      @script.setup
    end

    # Announce build
    #
    def announce
      @script.newline
      @script.cmd('echo "Bamboo Worker"')
      @script.newline
      @script.announce
    end

    # After result
    #
    def after_result
      self.if('$TEST_RESULT = 0') do |klass|
        build_custom_stage('after_success', klass)
      end if config['after_success']

      self.if('$TEST_RESULT != 0') do |klass|
        build_custom_stage('after_failure', klass)
      end if config['after_failure']
    end

    private

    # Test if stage should be asserted in the script
    #
    def assert_stage?(stage)
      [:before_install, :install, :before_script, :script].include?(stage)
    end

    # Custom export from line in file
    #
    # @param [String] line Line such as key=value
    def custom_export(line)
      key, value = line.split('=', 2).compact
      export key, value, echo: false
    end
  end
end
