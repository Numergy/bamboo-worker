# -*- coding: utf-8 -*-
require 'spec_helper'
require 'travis/yaml'
require 'bamboo-worker/core/string/indent'
require 'bamboo-worker/shell'
require 'bamboo-worker/script'
require 'bamboo-worker/stages'
require 'bamboo-worker/script/default'
require 'bamboo-worker/script/ruby'

# Template tests
module BambooWorker
  describe 'Stages' do
    include FakeFS::SpecHelpers

    before(:each) do
      travis = Travis::Yaml.load('
env:
  - DB=pgsql
before_install:
  - before_install_command_1
  - before_install_command_2
install:
  - install_command_1
  - install_command_2
before_script:
  - before_script_command_1
  - before_script_command_2
script:
  - script_command_1
  - script_command_2
after_success:
  - success_command_1
  - success_command_2
after_failure:
  - failure_command_1
  - failure_command_2
after_script:
  - after_script_command_1
  - after_script_command_2
')
      @stages = Stages.new(travis, Script::Ruby.new)
    end

    it 'should generate configuration' do
      expect(@stages.config).to be_a(Travis::Yaml::Nodes::Root)
    end

    it 'should build builtin stages' do
      expect(@stages.builtin_stages).to eq([:env, :announce])
      available = ['export BAMBOO=true',
                   'export CI=true',
                   'export CONTINIOUS_INTEGRATION=true',
                   'ruby --version',
                   'rbenv --version']
      @stages.nodes.each do |stage|
        expect(available).to include(stage.to_s)
      end
    end

    it 'should build custom stages' do
      expect(@stages.custom_stages)
        .to eq([:setup,
                :before_install,
                :install,
                :before_script,
                :script,
                :after_result,
                :after_script])
      available = %w(before_install_command_1
                     before_install_command_2
                     install_command_1
                     install_command_2
                     before_script_command_1
                     before_script_command_2
                     script_command_1
                     script_command_2
                     success_command_1
                     success_command_2
                     failure_command_1
                     failure_command_2
                     after_script_command_1
                     after_script_command_2)
      @stages.nodes.each do |stage|
        expect(available).to include(stage.to_s)
      end
    end
  end
end
