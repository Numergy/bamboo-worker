# -*- coding: utf-8 -*-
require 'spec_helper'
require 'yaml'
require 'bamboo-worker/config'

# Bamboo worker tests
module BambooWorker
  describe 'Config' do
    include FakeFS::SpecHelpers

    it 'should do nothing if there is no argument' do
      expect(Config.new).to eq({})
    end

    it 'should create files' do
      Config.new('/.bamboo/worker.yml')
      expect(File.directory?('/.bamboo')).to eq(true)
      expect(File.exist?('/.bamboo/worker.yml')).to eq(true)
    end

    it 'should load content' do
      Dir.mkdir('/.bamboo')
      yaml = <<-eos
test:
  with: something
eos
      File.write('/.bamboo/worker.yml', yaml)
      config = Config.new('/.bamboo/worker.yml')
      expect(config).to be_a(Hash)
      expect(config['test']['with']).to eq('something')
    end

    it 'should save configuration' do
      config = Config.new('/.bamboo/worker.yml')
      config['this'] = 'is sparta!'
      config.save
      expect(File.read('/.bamboo/worker.yml'))
        .to eq("--- !ruby/hash-with-ivars:BambooWorker::Config\n" \
               "elements:\n  this: is sparta!\nivars:\n  " \
               ":@config_file: \"/.bamboo/worker.yml\"\n")
    end
  end
end
