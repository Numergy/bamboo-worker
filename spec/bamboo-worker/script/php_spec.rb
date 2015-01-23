# -*- coding: utf-8 -*-
require 'spec_helper'
require 'travis/yaml'
require 'bamboo-worker/shell'
require 'bamboo-worker/script/default'
require 'bamboo-worker/script/php'

# Bamboo worker tests
module BambooWorker
  # ruby script tests
  describe 'Script::Php' do
    before(:each) do
      travis = Travis::Yaml.matrix('language: php
php: 5.4')
      @php = Script::Php.new(travis.first)
    end

    it 'should setup' do
      @php.setup
      expect(@php.nodes.map(&:to_s))
        .to eq(['export RBENV_VERSION=$(phpenv versions' \
                " | grep 5.4 | tail -1 | sed 's/[^0-9.]" \
                "*\\([0-9.]*\\).*/\\1/'| sed -e" \
                " 's/^[ \\t]*//')",
                "if [[ -z \"$RBENV_VERSION\" ]]; then\n  " \
                "export BAMBOO_CMD=no_script\n  " \
                "echo 'PHP version \\''5.4\\'' not found'\n  exit 1\nfi",
                'export BAMBOO_PHP_VERSION=5.4'])
    end

    it 'should announce' do
      @php.announce
      expect(@php.nodes.map(&:to_s))
        .to eq(['bamboo_cmd php\\ --version --echo',
                'bamboo_cmd phpenv\\ --version --echo'])
    end

    it 'should script' do
      @php.script
      expect(@php.nodes.map(&:to_s))
        .to eq(['export BAMBOO_CMD=no_script',
                "echo 'No script found.'",
                'exit 1'])
    end
  end
end
