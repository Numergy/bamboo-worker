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
      travis = Travis::Yaml.matrix('
ruby: 1.9.3
env:
  global:
    - DB=pgsql
  matrix:
    - USER=test
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

      @stages = Stages.new(Script::Ruby.new(travis.first))
    end

    it 'should build builtin stages' do
      expect(@stages.builtin_stages).to eq([:setup, :env, :announce])
      available = ['export RBENV_VERSION=$(rbenv versions |' \
                   ' grep 1.9.3 | tail -1 | ' \
                   "sed 's/[^0-9.]*\\([0-9.]*-[a-z0-9]*\\).*/\\1/'" \
                   "| sed -e 's/^[ \\t]*//')",
                   "if [[ -z \"$RBENV_VERSION\" ]]; then\n  " \
                   "echo '1.9.3 not found'\n  exit 1\nfi",
                   'export BAMBOO_STAGE=setup',
                   'export BAMBOO=true',
                   'export CI=true',
                   'export DB=pgsql',
                   'export USER=test',
                   'export BAMBOO_STAGE=env',
                   'export CONTINUOUS_INTEGRATION=true',
                   'export BAMBOO_STAGE=announce',
                   'echo',
                   'echo "Bamboo Worker"',
                   'echo',
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
      available = ["if [[ -f Gemfile ]]; then\n  bamboo_cmd bundle\\ install" \
                   " --retry\nfi",
                   'export BAMBOO_STAGE=before_install',
                   'bamboo_cmd before_install_command_1 --assert',
                   'bamboo_cmd before_install_command_2 --assert',
                   'export BAMBOO_STAGE=before_script',
                   'export BAMBOO_STAGE=install',
                   'bamboo_cmd before_script_command_1 --assert',
                   'bamboo_cmd before_script_command_2 --assert',
                   'export BAMBOO_STAGE=script',
                   'bamboo_cmd script_command_1 --assert',
                   'bamboo_cmd script_command_2 --assert',
                   'export BAMBOO_STAGE=after_result',
                   "if [[ $TEST_RESULT = 0 ]]; then\n  " \
                   "success_command_1\n  success_command_2\nfi",
                   "if [[ $TEST_RESULT != 0 ]]; then\n  " \
                   "failure_command_1\n  failure_command_2\nfi",
                   'export BAMBOO_STAGE=after_script',
                   'after_script_command_1',
                   'after_script_command_2']
      @stages.nodes.each do |stage|
        expect(available).to include(stage.to_s)
      end
    end

    it 'should play with simple env vars' do
      travis = Travis::Yaml.matrix('
ruby:
  - 1.9.3
env:
  - DB=pgsql
  - DB=mysql
').to_enum

      stages = Stages.new(Script::Ruby.new(travis.next))
      stages.env
      available = ['export BAMBOO=true',
                   'export CI=true',
                   'export CONTINUOUS_INTEGRATION=true',
                   'export DB=pgsql']
      stages.nodes.each do |stage|
        expect(available).to include(stage.to_s)
      end

      stages = Stages.new(Script::Ruby.new(travis.next))
      stages.env
      available = ['export BAMBOO=true',
                   'export CI=true',
                   'export CONTINUOUS_INTEGRATION=true',
                   'export DB=mysql']
      stages.nodes.each do |stage|
        expect(available).to include(stage.to_s)
      end
    end

    it 'should play with complex env vars' do
      travis = Travis::Yaml.matrix('
ruby:
  - 1.9.3
env:
  global:
    - USER=test
  matrix:
    - DB=pgsql
    - DB=mysql
').to_enum

      stages = Stages.new(Script::Ruby.new(travis.next))
      stages.env
      available = ['export BAMBOO=true',
                   'export USER=test',
                   'export CI=true',
                   'export CONTINUOUS_INTEGRATION=true',
                   'export DB=pgsql']
      stages.nodes.each do |stage|
        expect(available).to include(stage.to_s)
      end

      stages = Stages.new(Script::Ruby.new(travis.next))
      stages.env
      available = ['export BAMBOO=true',
                   'export USER=test',
                   'export CI=true',
                   'export CONTINUOUS_INTEGRATION=true',
                   'export DB=mysql']
      stages.nodes.each do |stage|
        expect(available).to include(stage.to_s)
      end
    end
  end
end
