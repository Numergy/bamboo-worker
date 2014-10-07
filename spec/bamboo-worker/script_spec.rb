# -*- coding: utf-8 -*-
require 'spec_helper'
require 'travis/yaml'
require 'bamboo-worker/shell'
require 'bamboo-worker/script'
require 'bamboo-worker/script/default'
require 'bamboo-worker/script/ruby'
require 'bamboo-worker/stages'

# Template tests
module BambooWorker
  describe 'Script' do
    include FakeFS::SpecHelpers

    it 'should raise execption when file does not exists' do
      expect { Script.new('undefined') }
        .to raise_error(ArgumentError, 'File "undefined" not found')
    end

    it 'should generate configuration' do
      File.open('.travis.yml', 'w').write('language: ruby')
      script = Script.new('.travis.yml')
      expect(script.config).to be_a(Travis::Yaml::Nodes::Root)
    end
  end
end
