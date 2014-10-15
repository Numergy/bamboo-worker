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
ruby: 1.9.3
env:
  - DB=pgsql
before_install:
  - before_install_command_1
  - before_install_command_2
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
      @stages = Stages.new(Script::Ruby.new(travis))
    end

    it 'should generate configuration' do
      expect(@stages.config).to be_a(Hash)
      expect(@stages.config['gemfile']).to eq('Gemfile')
    end

    it 'should build builtin stages' do
      expect(@stages.builtin_stages).to eq([:setup, :env, :announce])
      available = ['rbenv local 1.9.3',
                   'export BAMBOO=true',
                   'export CI=true',
                   'export CONTINIOUS_INTEGRATION=true',
                   'ruby --version',
                   'rbenv --version',
                   "if [[ -f Gemfile ]]; then\n  bundle --version\nfi"]
      @stages.nodes.each do |stage|
        expect(available).to include(stage.to_s)
      end
    end

    it 'should build custom stages' do
      expect(@stages.custom_stages)
        .to eq([:before_install,
                :install,
                :before_script,
                :script,
                :after_result,
                :after_script])
      available = ["if [[ -f Gemfile ]]; then\n  bundle install\nfi",
                   'before_install_command_1',
                   'before_install_command_2',
                   'before_script_command_1',
                   'before_script_command_2',
                   'script_command_1',
                   'script_command_2',
                   "if [[ $TEST_RESULT = 0 ]]; then\n  " \
                   "success_command_1\n  success_command_2\nfi",
                   "if [[ $TEST_RESULT != 0 ]]; then\n  " \
                   "failure_command_1\n  failure_command_2\nfi",
                   'failure_command_1',
                   'failure_command_2',
                   'after_script_command_1',
                   'after_script_command_2']
      @stages.nodes.each do |stage|
        expect(available).to include(stage.to_s)
      end
    end
  end
end
