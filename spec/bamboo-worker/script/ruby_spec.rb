# -*- coding: utf-8 -*-
require 'spec_helper'
require 'travis/yaml'
require 'bamboo-worker/shell'
require 'bamboo-worker/script/default'
require 'bamboo-worker/script/ruby'

# Bamboo worker tests
module BambooWorker
  # ruby script tests
  describe 'Script::Ruby' do
    before(:each) do
      travis = Travis::Yaml.matrix('ruby: 1.9.3')
      @ruby = Script::Ruby.new(travis.first)
    end

    it 'should setup' do
      @ruby.setup
      expect(@ruby.nodes.map(&:to_s))
        .to eq(['export RBENV_VERSION=$(rbenv versions' \
                " | grep 1.9.3 | tail -1 | sed 's/[^0-9.]" \
                "*\\([0-9.]*-[a-z0-9]*\\).*/\\1/'| sed -e" \
                " 's/^[ \\t]*//')",
                "if [[ -z \"$RBENV_VERSION\" ]]; then\n  " \
                "export BAMBOO_CMD=no_script\n  " \
                "echo '1.9.3 not found'\n  exit 1\nfi",
                'export BAMBOO_RUBY_VERSION=1.9.3'])
    end

    it 'should announce' do
      @ruby.announce
      expect(@ruby.nodes.map(&:to_s))
        .to eq(['bamboo_cmd ruby\\ --version --echo',
                'bamboo_cmd rbenv\\ --version --echo',
                "if [[ -f Gemfile ]]; then\n  bamboo_cmd " \
                "bundle\\ --version --echo\nfi"])
    end

    it 'should install' do
      @ruby.install
      expect(@ruby.nodes.map(&:to_s))
        .to eq(["if [[ -f Gemfile ]]; then\n  " \
                "bamboo_cmd bundle\\ install --echo --retry\nfi"])
    end

    it 'should script' do
      @ruby.script
      expect(@ruby.nodes.map(&:to_s))
        .to eq(["if [[ -f Gemfile ]]; then\n  " \
                "bamboo_cmd bundle\\ exec\\ rake --assert --echo\nelse\n  " \
                "bamboo_cmd rake --assert --echo\nfi"])
    end
  end
end
