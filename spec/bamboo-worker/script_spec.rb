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

    it 'should raise execption when directory does not exists' do
      expect { Script.new('undefined', '.travis.yml') }
        .to raise_error(ArgumentError, 'Directory "undefined" not found')
    end

    it 'should raise execption when file does not exists' do
      FileUtils.mkdir_p('/tmp')
      expect { Script.new('/tmp', '.travis.yml') }
        .to raise_error(ArgumentError, 'File ".travis.yml" not found')
    end

    it 'should raise error if language is not found' do
      FileUtils.mkdir_p('/tmp')
      File.open('/tmp/.travis.yml', 'w').write('language: erlang')

      expect { Script.new('/tmp', '.travis.yml') }
        .to raise_error(ArgumentError, /Can't load "erlang" language/)
    end

    it 'should initialize script' do
      FileUtils.mkdir_p('/tmp')
      File.open('/tmp/.travis.yml', 'w').write('language: ruby')

      stages = Script.new('/tmp', '.travis.yml').stages
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

      FileUtils.mkdir_p('/tmp')
      File.open('/tmp/.travis.yml', 'w').write('language: ruby')

      stages = Script.new('/tmp', '.travis.yml').compile
      expect(stages).to be_a(Array)
      expect(stages.first).to be_a(String)
    end
  end
end
