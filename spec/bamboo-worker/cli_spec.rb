# -*- coding: utf-8 -*-
require 'spec_helper'
require 'bamboo-worker/cli'
require 'slop'

# Bamboo worker tests
module BambooWorker
  # CLI tests
  module CLI
    describe 'CLI' do
      it 'should return options' do
        options = CLI.options
        expect(options).to be_a(::Slop)
        expect(options.config[:banner])
          .to eq('Usage: bamboo-worker [COMMAND] [OPTIONS]')
        expect(options.to_s)
          .to match(/-v, --version(\s+)Shows the current version/)
        expect(options.to_s)
          .to match(/-h, --help(\s+)Display this help message./)

        version = options.fetch_option(:v)
        expect(version.short).to eq('v')
        expect(version.long).to eq('version')
        expect { version.call }.to output(/bamboo-worker v.* on ruby/).to_stdout
      end

      it 'should retrieve version information' do
        expect(CLI.version_information).to eq(
          "bamboo-worker v#{VERSION} on #{RUBY_DESCRIPTION}"
        )
      end

      it 'should return current directory' do
        allow(Dir).to receive(:pwd).and_return('/tmp/test')
        expect(CLI.current_dir).to eq('/tmp/test')
      end

      it 'should return travis configuration path' do
        allow(Dir).to receive(:pwd).and_return('/tmp/test')
        expect(CLI.config_path('.ci.yml')).to eq('/tmp/test/.ci.yml')
      end

      it 'should return travis configuration path from env var' do
        stub_const('ENV', 'TRAVIS_YAML' => '.ci.yml')
        expect(CLI.config_path('.ci.yml')).to eq('.ci.yml')
      end

      it 'should return travis configuration path' do
        allow(File).to receive(:expand_path)
          .and_return('/tmp/test/.bamboo/worker.yml')
        expect(CLI.worker_config_path).to eq('/tmp/test/.bamboo/worker.yml')
      end

      it 'should return travis configuration path from env var' do
        stub_const('ENV', 'WORKER_YAML' => '.worker.yml')
        expect(CLI.worker_config_path).to eq('.worker.yml')
      end
    end
  end
end
