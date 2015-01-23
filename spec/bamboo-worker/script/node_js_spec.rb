# -*- coding: utf-8 -*-
require 'spec_helper'
require 'travis/yaml'
require 'bamboo-worker/shell'
require 'bamboo-worker/script/default'
require 'bamboo-worker/script/node_js'

# Bamboo worker tests
module BambooWorker
  # ruby script tests
  describe 'Script::NodeJs' do
    before(:each) do
      travis = Travis::Yaml.matrix('language: node_js
node: 0.10')
      @node_js = Script::NodeJs.new(travis.first)
    end

    it 'should setup' do
      @node_js.setup
      expect(@node_js.nodes.map(&:to_s))
        .to eq(['export NDENV_VERSION=$(ndenv versions' \
                " | grep 0.10 | tail -1 | sed 's/[^0-9.]" \
                "*\\(v[0-9.]*\\).*/\\1/'| sed -e" \
                " 's/^[ \\t]*//')",
                "if [[ -z \"$NDENV_VERSION\" ]]; then\n  " \
                "export BAMBOO_CMD=no_script\n  " \
                "echo 'Node js version \\''0.10\\'' not found'\n  exit 1\nfi",
                'export BAMBOO_NODE_VERSION=0.10'])
    end

    it 'should announce' do
      @node_js.announce
      expect(@node_js.nodes.map(&:to_s))
        .to eq(['bamboo_cmd node\\ --version --echo',
                'bamboo_cmd npm\\ --version --echo',
                'bamboo_cmd ndenv\\ --version --echo'])
    end

    it 'should install' do
      @node_js.install
      expect(@node_js.nodes.map(&:to_s))
        .to eq(["if [[ -f package.json ]]; then\n  " \
                "bamboo_cmd npm\\ install --echo --retry\nfi"])
    end

    it 'should script' do
      @node_js.script
      expect(@node_js.nodes.map(&:to_s))
        .to eq(["if [[ -f package.json ]]; then\n  bamboo_cmd npm\\ " \
                "test --assert --echo\nelse\n  bamboo_cmd make\\ test" \
                " --assert --echo\nfi"])
    end
  end
end
