# -*- coding: utf-8 -*-
require 'spec_helper'
require 'travis/yaml'
require 'bamboo-worker/shell'
require 'bamboo-worker/script/default'
require 'bamboo-worker/script/python'

# Bamboo worker tests
module BambooWorker
  # python script tests
  describe 'Script::Python' do
    before(:each) do
      travis = Travis::Yaml.matrix('language: python
python: 3.3')
      @python = Script::Python.new(travis.first)
    end

    it 'should setup' do
      @python.setup
      expect(@python.nodes.map(&:to_s))
        .to eq(["export PYENV_VERSION=$(pyenv versions | grep ' 3.3' " \
                "| tail -1 | sed 's/[^0-9.]*\\([0-9.]*\\).*/\\1/'| " \
                "sed -e 's/^[ \\t]*//')",
                "if [[ -z \"$PYENV_VERSION\" ]]; then\n  export " \
                "BAMBOO_CMD=no_script\n  echo '3.3 not found'\n  exit 1\nfi",
                'export BAMBOO_PYTHON_VERSION=3.3'])
    end

    it 'should announce' do
      @python.announce
      expect(@python.nodes.map(&:to_s))
        .to eq(['python --version',
                'pip --version',
                'pyenv --version'])
    end

    it 'should install' do
      @python.install
      expect(@python.nodes.map(&:to_s))
        .to eq(["if [[ -f Requirements.txt ]]; then\n  bamboo_cmd " \
                "pip\\ install\\ -r\\ Requirements.txt --retry\nelif" \
                " [[ -f requirements.txt ]]; then\n  bamboo_cmd " \
                "pip\\ install\\ -r\\ requirements.txt --retry\nelse\n" \
                "  echo 'Could not locate requirements.txt.'\nfi"])
    end

    it 'should script' do
      @python.script
      expect(@python.nodes.map(&:to_s))
        .to eq(['export BAMBOO_CMD=no_script',
                "echo 'No script found.'",
                'exit 1'])
    end
  end
end
