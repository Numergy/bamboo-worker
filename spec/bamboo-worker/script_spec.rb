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

    it 'should retrieve environment variable instead of parameter' do
      stub_const('ENV', 'TRAVIS_YAML' => '.ci.yml')
      expect { Script.new('.travis.yml') }
        .to raise_error(ArgumentError, 'File ".ci.yml" not found')
    end

    it 'should raise execption when file does not exists' do
      expect { Script.new('.travis.yml') }
        .to raise_error(ArgumentError, 'File ".travis.yml" not found')
    end

    it 'should raise error if language is not found' do
      File.open('.travis.yml', 'w').write('language: erlang')

      expect { Script.new('.travis.yml') }
        .to raise_error(ArgumentError, /Can't load "erlang" language/)
    end

    it 'should initialize script' do
      File.open('.travis.yml', 'w').write('language: ruby')

      stages = Script.new('.travis.yml').stages
      expect(stages).to be_a(Array)
      expect(stages.first).to be_a(Stages)
      expect(stages.first.script).to be_a(Script::Ruby)
    end

    it 'should compile scripts' do
      FakeFS::FileSystem
        .clone(File
                 .expand_path('../../../',
                              Pathname
                                .new(__FILE__).realpath))

      File.open('.travis.yml', 'w').write('language: ruby')

      stages = Script.new('.travis.yml').compile
      expect(stages).to be_a(Array)
      expect(stages.first).to be_a(String)
    end
  end
end
